import os
from tempfile import NamedTemporaryFile

import numpy as np

from tqdm import tqdm

from kubernetes import config, client, watch
from prometheus_client import Counter, start_http_server

from ocifs import OCIFileSystem

import pyarrow.feather

from sentence_transformers import SentenceTransformer

import faiss

# Preamble: configuration, metrics

DOMAIN = "new.artificialwisdom.cloud"
RESOURCE_VERSION = ""

MAIN_LOOP_ITERATIONS = Counter("main_loop_iterations",
                               "Number of times main loop has restarted")
OBJECTS_PROCESSED = Counter("objects_processed",
                            "Number of objects processed")

fs = OCIFileSystem(config=os.environ["OCI_CONFIG"], profile="DEFAULT")

if "KUBERNETES_PORT" in os.environ:
    config.load_incluster_config()
else:
    config.load_kube_config()

start_http_server(8000)

# Sentence embedding setup

embedder = SentenceTransformer("all-miniLM-L6-v2")
EMBEDDING_WIDTH = 384

def normedEmbeds(arr):
    # https://github.com/facebookresearch/faiss/wiki/MetricType-and-distances
    rv = np.array(arr, dtype="float32")
    faiss.normalize_L2(rv)
    return rv

# Controller: API, handlers, event loop

crds = client.CustomObjectsApi()

def updateObject(obj):
    crds.replace_namespaced_custom_object(DOMAIN, "v1",
                                          obj["metadata"]["namespace"],
                                          "vectorindices", obj["metadata"]["name"],
                                          obj)

def setPhase(obj, phase): obj.setdefault("status", {})["phase"] = phase

def getDataSet(name, ns):
    return crds.get_namespaced_custom_object(DOMAIN, "v1", ns, "datasets", name)

def bucketPath(obj):
    filename = obj["spec"]["filename"]
    bucket = obj["spec"]["bucket"]
    return f"oci://{bucket}/{filename}"

MB = 1024 ** 2
def slowCopy(src, dest):
    while True:
        hunk = src.read(MB)
        if not hunk: break
        dest.write(hunk)

def awaitingDataSet(obj):
    ds = getDataSet(obj["spec"]["dataset"], obj["metadata"]["namespace"])
    if ds["status"].get("phase") == "Ready":
        setPhase(obj, "BuildingIndex")
        updateObject(obj)

def buildingIndex(obj):
    ds = getDataSet(obj["spec"]["dataset"], obj["metadata"]["namespace"])
    factory = obj["spec"]["factory"]
    index = faiss.index_factory(EMBEDDING_WIDTH, factory)
    print("DataSet and factory are valid!")
    with fs.open(bucketPath(ds), "rb") as handle:
        df = pyarrow.feather.read_feather(handle)
    print("Opened Feather data!")
    for row in tqdm(df.iterrows(), total=df.size):
        # XXX quirk of test data?
        batch = row[1].to_list()[0]
        embeddings = normedEmbeds(embedder.encode(batch))
        index.add(embeddings)
    with NamedTemporaryFile(mode="rb") as temp:
        faiss.write_index(index, temp.name)
        with fs.open(bucketPath(obj), "wb") as handle:
            slowCopy(temp, handle)
    setPhase(obj, "Ready")
    updateObject(obj)

def ready(obj): pass

def defaultHandler(obj):
    ds = getDataSet(obj["spec"]["dataset"], obj["metadata"]["namespace"])
    print("DataSet:", ds)
    if ds["status"].get("phase") == "Ready": setPhase(obj, "BuildingIndex")
    else: setPhase(obj, "AwaitingDataSet")
    updateObject(obj)

dispatch = {
    "AwaitingDataSet": awaitingDataSet,
    "BuildingIndex": buildingIndex,
    "Ready": ready,
}

while True:
    MAIN_LOOP_ITERATIONS.inc()
    stream = watch.Watch().stream(
            crds.list_cluster_custom_object,
            DOMAIN, "v1",
            "vectorindices", resource_version=RESOURCE_VERSION)
    for event in stream:
        OBJECTS_PROCESSED.inc()
        obj = event["object"]
        phase = obj.get("status", {}).get("phase")
        print("Object:", obj["metadata"]["name"], "Phase:", phase)
        dispatch.get(phase, defaultHandler)(obj)
