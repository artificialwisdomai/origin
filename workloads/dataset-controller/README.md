== Dataset Controller ==

A simple controller for `datasets.new.artificial.cloud` custom objects.

This controller looks up datasets on HF Hub using HF Datasets, and then uploads
them to OCI in Feather format. (Or at least, that's the plan.)

A Dockerfile is included for convenience.

=== Rancher/k3s ===

Make sure to export `KUBECONFIG`:

    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

Then also add it to the container environment:

    podman run -E KUBECONFIG ...
