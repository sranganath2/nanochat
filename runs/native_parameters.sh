#!/usr/bin/env bash
set -euo pipefail

bash runs/bootstrap_cache.sh "$HOME/.cache/nanochat_native" 170

export NANOCHAT_BASE_DIR="$HOME/.cache/nanochat_native"
unset NANOCHAT_TOKENIZER_KIND

PYTHONPATH=. python -m scripts.base_train \
  --depth 4 \
  --max-seq-len 128 \
  --window-pattern L \
  --device-batch-size 2 \
  --total-batch-size 1024 \
  --num-iterations 300 \
  --eval-every 50 \
  --core-metric-every -1 \
  --sample-every -1 \
  --save-every -1 \
  --run dummy
