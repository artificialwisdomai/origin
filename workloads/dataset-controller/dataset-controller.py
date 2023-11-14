import os

from kubernetes import config, client, watch
from prometheus_client import Counter, start_http_server

from ocifs import OCIFileSystem

import pyarrow.feather
from datasets import load_dataset

# Preamble: configuration, metrics

DOMAIN = "new.artificialwisdom.cloud"
RESOURCE_VERSION = ""

MAIN_LOOP_ITERATIONS = Counter("main_loop_iterations",
                               "Number of times main loop has restarted")
OBJECTS_PROCESSED = Counter("objects_processed",
                            "Number of objects processed")
DATASETS_RETRIEVED = Counter("datasets_retrieved",
                             "Number of datasets retrieved")

fs = OCIFileSystem(config=os.environ["OCI_CONFIG"], profile="DEFAULT")

if "KUBERNETES_PORT" in os.environ:
    config.load_incluster_config()
else:
    config.load_kube_config()

start_http_server(8000)

# Controller: API, handlers, event loop

crds = client.CustomObjectsApi()

def updateObject(obj):
    crds.replace_namespaced_custom_object(DOMAIN, "v1",
                                          obj["metadata"]["namespace"],
                                          "datasets", obj["metadata"]["name"],
                                          obj)

def setPhase(obj, phase): obj.setdefault("status", {})["phase"] = phase

def retrieveHFDataset(name, remote):
    ds = load_dataset(name)["train"]
    df = ds.to_pandas()
    with fs.open(remote, "wb") as handle:
        pyarrow.feather.write_feather(df, handle, compression="zstd")
    DATASETS_RETRIEVED.inc()

def unknownSource(obj): pass

def notPresent(obj):
    # XXX trusting that source is valid
    name = obj["spec"]["source"][3:]
    filename = obj["spec"]["filename"]
    bucket = obj["spec"]["bucket"]
    remote = f"oci://{bucket}/{filename}"
    retrieveHFDataset(name, remote)
    setPhase(obj, "Ready")
    updateObject(obj)

def ready(obj): pass

def defaultHandler(obj):
    source = obj["spec"]["source"]
    if source.startswith("hf:"): setPhase(obj, "NotPresent")
    else: setPhase(obj, "UnknownSource")
    updateObject(obj)

dispatch = {
    "UnknownSource": unknownSource,
    "NotPresent": notPresent,
    "Ready": ready,
}

while True:
    MAIN_LOOP_ITERATIONS.inc()
    stream = watch.Watch().stream(
            crds.list_cluster_custom_object,
            DOMAIN, "v1",
            "datasets", resource_version=RESOURCE_VERSION)
    for event in stream:
        OBJECTS_PROCESSED.inc()
        obj = event["object"]
        phase = obj.get("status", {}).get("phase")
        print("Object:", obj["metadata"]["name"], "Phase:", phase)
        dispatch.get(phase, defaultHandler)(obj)
