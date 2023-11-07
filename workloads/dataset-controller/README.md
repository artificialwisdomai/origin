== Dataset Controller ==

A simple controller for `datasets.new.artificialwisdom.cloud` custom objects.

This controller looks up datasets on HF Hub using HF Datasets, and then uploads
them to OCI in Feather format. (Or at least, that's the plan.)

A Dockerfile is included for convenience.

=== OCI Configuration ===

To access OCI, bind-mount a configuration file. For example, to bind-mount
`~/.oci/config`, try something like:

    export OCI_CONFIG=/app/oci/config
    podman -e OCI_CONFIG -v ~/.oci:/app/oci:ro ...

=== Rancher/k3s ===

Make sure to export `KUBECONFIG`:

    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

Then also add it to the container environment:

    podman run -e KUBECONFIG ...

=== Complete example ====

    export IMAGE=$(podman build .)
    export KUBECONFIG=/app/kube/k3s.yaml
    export OCI_CONFIG=/app/oci
    podman run --env-host -v /etc/rancher/k3s:/app/kube:ro -v ~/.oci:/app/oci:ro --net host $IMAGE
