FROM rust:1.65 AS builder

# This is the commit hash of the version of electrs we want to build
ARG ESPLORA_BUILD_CHECKOUT="27ccf60e87c985f9966110f8c1eb184ff8767cc0"

ARG VERSION=0.3.0

# Update and install build-essential
RUN apt-get update && apt-get install -y clang cmake build-essential

# Clone the electrs repository and checkout the commit we want to build
WORKDIR /app
RUN git clone https://github.com/bitlightlabs/electrs.git
WORKDIR /app/electrs
RUN git checkout $ESPLORA_BUILD_CHECKOUT

# Build electrs
RUN CARGO_NET_GIT_FETCH_WITH_CLI=true \
    cargo build --release --locked


FROM debian:bullseye-slim

LABEL maintainer="BitLight"
LABEL description="Bitlight Local Env Esplora API Server Image, powerby Blockstream/electrs"
LABEL VERSION=${ESPLORA_BUILD_CHECKOUT}

COPY --from=builder /app/electrs/target/release/electrs /usr/local/bin/electrs

ENTRYPOINT ["electrs"]
