#!/usr/bin/env bash
set -e
set -o noglob

apt-get update -y && apt-get install -y --no-install-recommends \
    openssl ca-certificates \
    pkg-config libssl-dev \
    xgboost libclang-dev \
    direnv fzf \
    gettext \
    jq \
    python3 python3-pip


export LIBCLANG_PATH=/usr/lib/llvm-11/lib

rustup component add rustfmt