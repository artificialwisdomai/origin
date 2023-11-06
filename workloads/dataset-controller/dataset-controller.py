import os

from kubernetes import config, client, watch

from datasets import load_dataset

DOMAIN = "new.artificialwisdom.cloud"
RESOURCE_VERSION = ""

if "KUBERNETES_PORT" in os.environ:
    config.load_incluster_config()
else:
    config.load_kube_config()

crds = client.CustomObjectsApi()
for i in range(10):
    print("main loop")
    stream = watch.Watch().stream(
            crds.list_cluster_custom_object,
            DOMAIN, "v1",
            "datasets", resource_version=RESOURCE_VERSION)
    for event in stream:
        obj = event["object"]
        print("Got obj", obj)
        source = obj["spec"]["source"]
        print("source", source)
        if source.startswith("hf:"):
            ds = load_dataset(source[3:])
            print("got dataset", ds)
