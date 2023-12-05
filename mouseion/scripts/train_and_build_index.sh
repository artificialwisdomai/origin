###
#
# Copyright Computelify, Inc.
#
# This trains and builds an index.
#
# Author: Steven Dake <steve@computelify.com>
# License: ASL2.

MOUSEION_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"

SOURCE_PATH="${MOUSEION_PATH}/mouseion"
REALNEWS_PATH="${MOUSEION_PATH}/knowledge.d/realnews.d"
DATACOLLECTION_SPECS_PATH="${MOUSEION_PATH}/datacollection_specs"

# Other variables remain the same
HYPERFINE_ARGS="--runs 1 --warmup 0 --show-output --time-unit second --command-name train-index 'python train_build_index.py'"
WORKLOAD_CMD="python '${SOURCE_PATH}/train_and_build_index.py' \
               --spec '${DATACOLLECTION_SPECS_PATH}/train_realnews_dataset_spec.json' \
               --index-type 'IVF131072,PQ32' \
               --output '${REALNEWS_PATH}/realnews.index' \
               --use-gpus \
               --batch-size 32768"

hyperfine "${HYPERFINE_ARGS} ${WORKLOAD_CMD}"
