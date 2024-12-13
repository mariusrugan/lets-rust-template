#
# Chef stage
#
FROM lukemathwalker/cargo-chef:latest-rust-1 AS chef

WORKDIR /app/

RUN apt update && apt install lld clang xgboost libclang-dev -y

#
# Planner stage
#
FROM chef AS planner

COPY . .

RUN cargo chef prepare --recipe-path recipe.json

#
# Builder stage
#
FROM chef AS builder

COPY --from=planner /app/recipe.json recipe.json

RUN cargo chef cook --release --recipe-path recipe.json

COPY . .

RUN cargo build --release --bin lets-rust

#
# Runtime stage
#
FROM debian:bookworm-slim AS runtime

WORKDIR /app

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* 

COPY --from=builder /app/target/release/lets-rust lets-rust

ENTRYPOINT ["./lets-rust"]