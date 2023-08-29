###
#
# vllm depends on ray for tensor parallelism
#
# --head: initial head ray deployment.
# --disable-usage-stats: turn off ray telemetry reporting, ie spying.

ray start --head --disable-usage-stats
