# Cloud Core API

This is a quick and dirty OpenAPI-oriented JSON-over-HTTP service for
configuring our cloud core stuff.

## Build and run

```bash
export IMAGE=$(podman build cloud/core)
podman run -e PORT=8000 -p 8000:8000 $IMAGE
```

And then, in another terminal:

```bash
curl localhost:8000 | jq .
```
