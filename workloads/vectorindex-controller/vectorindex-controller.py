import os

from kubernetes import config, client, watch
from prometheus_client import Counter, start_http_server

import faiss

# Preamble: configuration, metrics

DOMAIN = "new.artificialwisdom.cloud"
RESOURCE_VERSION = ""

MAIN_LOOP_ITERATIONS = Counter("main_loop_iterations",
                               "Number of times main loop has restarted")
OBJECTS_PROCESSED = Counter("objects_processed",
                            "Number of objects processed")

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
                                          "vectorindices", obj["metadata"]["name"],
                                          obj)

def setPhase(obj, phase): obj.setdefault("status", {})["phase"] = phase

def getDataSet(name, ns):
    return crds.get_namespaced_custom_object(DOMAIN, "v1", ns, "datasets", name)

def awaitingDataSet(obj):
    ds = getDataSet(obj["spec"]["dataset"], obj["metadata"]["namespace"])
    if ds["status"].get("phase") == "Ready":
        setPhase(obj, "BuildingIndex")
        updateObject(obj)

def buildingIndex(obj):
    ds = getDataSet(obj["spec"]["dataset"], obj["metadata"]["namespace"])
    factory = obj["spec"]["factory"]
    index = faiss.index_factory(128, factory)
    print("Index:", index)

def defaultHandler(obj):
    ds = getDataSet(obj["spec"]["dataset"], obj["metadata"]["namespace"])
    print("DataSet:", ds)
    if ds["status"].get("phase") == "Ready": setPhase(obj, "BuildingIndex")
    else: setPhase(obj, "AwaitingDataSet")
    updateObject(obj)

dispatch = {
    "AwaitingDataSet": awaitingDataSet,
    "BuildingIndex": buildingIndex,
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
