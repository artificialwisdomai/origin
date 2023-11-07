import os

from kubernetes import config, client, watch
from prometheus_client import Counter, start_http_server

from ocifs import OCIFileSystem

import pyarrow.feather
from datasets import load_dataset

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

crds = client.CustomObjectsApi()
while True:
    MAIN_LOOP_ITERATIONS.inc()
    stream = watch.Watch().stream(
            crds.list_cluster_custom_object,
            DOMAIN, "v1",
            "datasets", resource_version=RESOURCE_VERSION)
    for event in stream:
        OBJECTS_PROCESSED.inc()
        obj = event["object"]
        source = obj["spec"]["source"]
        if source.startswith("hf:"):
            name = source[3:]
            print("Retrieving dataset from HF", name)
            ds = load_dataset(name)["train"]
            df = ds.to_pandas()
            filename = obj["spec"]["filename"]
            bucket = obj["spec"]["bucket"]
            remote = f"oci://{bucket}/{filename}"
            print("Copying dataset to", remote)
            with fs.open(remote, "wb") as handle:
                pyarrow.feather.write_feather(df, handle, compression="zstd")
            print("Upload successful!")
        else:
            print("Not sure what to do with source", source)
