###
#
# Start vllm openai-like api server
#
# --model: identify model to inference
# --tokenizer: identify tokenizer to use with model
# --tensor-parallel-size: how much tensor parallelism to apply
# --host: Bind to interface identified by the host IP address.
# --port: Bind to specific port
# --served-model-name: Name of the model served via the openai like
#   next token prediction API.
# RAY_record_ref_creation_sites: environment variable to set benchmarking for https://docs.ray.io/en/latest/serve/index.html#rayserve
#
# Parallelism strategies:
# - https://huggingface.co/transformers/v4.9.2/parallelism.html
# - There are additional strategies not documented or invented yet
#   such as:
#
# P0. parallel decoding

RAY_record_ref_creation_sites=1 python -m vllm.entrypoints.openai.api_server --model /mnt/ubuntu/llama2/13B-chat --tokenizer /mnt/ubuntu/llama2/llama-tokenizer --tensor-parallel-size 4 --host 0.0.0.0 --port 9080 --served-model-name ModelT
