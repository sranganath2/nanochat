#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <base_dir> [num_shards]"
  exit 1
fi

export NANOCHAT_BASE_DIR="$1"
unset NANOCHAT_TOKENIZER_KIND

NUM_SHARDS="${2:-170}"
DATA_DIR="$NANOCHAT_BASE_DIR/base_data_climbmix"
TOKENIZER_DIR="$NANOCHAT_BASE_DIR/tokenizer"

mkdir -p "$NANOCHAT_BASE_DIR"

if [ ! -d "$DATA_DIR" ] || [ -z "$(find "$DATA_DIR" -maxdepth 1 -name '*.parquet' -print -quit 2>/dev/null)" ]; then
  echo "Dataset shards not found in $DATA_DIR"
  echo "Downloading $NUM_SHARDS ClimbMix shards..."
  PYTHONPATH=. python -m nanochat.dataset -n "$NUM_SHARDS"
else
  echo "Found dataset shards in $DATA_DIR"
fi

if [ ! -f "$TOKENIZER_DIR/tokenizer.pkl" ]; then
  echo "Tokenizer not found in $TOKENIZER_DIR"
  echo "Training tokenizer..."
  PYTHONPATH=. python -m scripts.tok_train
else
  echo "Found tokenizer at $TOKENIZER_DIR/tokenizer.pkl"
fi
