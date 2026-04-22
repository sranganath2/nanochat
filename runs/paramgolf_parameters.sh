#!/usr/bin/env bash
set -euo pipefail

export NANOCHAT_BASE_DIR="$HOME/.cache/nanochat_pg"
export NANOCHAT_TOKENIZER_KIND=sentencepiece

PG_DATA_PATH="../parameter-golf/data/datasets/fineweb10B_sp1024"
PG_TOKENIZER_MODEL="../parameter-golf/data/tokenizers/fineweb_1024_bpe.model"
PG_TOKENIZER_VOCAB="../parameter-golf/data/tokenizers/fineweb_1024_bpe.vocab"

mkdir -p "$NANOCHAT_BASE_DIR/tokenizer"

ln -sf "$(realpath "$PG_TOKENIZER_MODEL")" "$NANOCHAT_BASE_DIR/tokenizer/$(basename "$PG_TOKENIZER_MODEL")"
ln -sf "$(realpath "$PG_TOKENIZER_VOCAB")" "$NANOCHAT_BASE_DIR/tokenizer/$(basename "$PG_TOKENIZER_VOCAB")"

PYTHONPATH=. python -m scripts.build_token_bytes \
  --tokenizer-model "$PG_TOKENIZER_MODEL" \
  --out-dir "$NANOCHAT_BASE_DIR/tokenizer"

PYTHONPATH=. python -m scripts.test_paramgolf_tokenizer

PYTHONPATH=. python -m scripts.base_train \
  --dataset-kind paramgolf \
  --pg-data-path ../parameter-golf/data/datasets/fineweb10B_sp1024 \
  --depth 6 \
  --max-seq-len 256 \
  --window-pattern L \
  --device-batch-size 2 \
  --total-batch-size 1024 \
  --num-iterations 300 \
  --eval-every 50 \
  --core-metric-every -1 \
  --sample-every -1 \
  --save-every -1 \
  --run pg_d6_seq256
