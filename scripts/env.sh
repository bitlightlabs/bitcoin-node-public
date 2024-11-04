#!/usr/bin/env bash
set -e

ENV_LIST=(
  NETWORK
  RPC_PORT
  ZMQ_PORT
  EXPLORE_API_PORT
  EXPLORE_UI_PORT
  DATA_DIR
)
# check variables is all set in list
IS_ALL_SET=true

for env in "${ENV_LIST[@]}"; do
    if [ -z "${!env}" ]; then
        echo "Error: $env is not set"
        IS_ALL_SET=false
    else
      echo "export $env=${!env}"
      export "$env"
    fi
done

if [ "$IS_ALL_SET" = false ]; then
    echo "Error: Not all environment variables are set"
    exit 1
fi
echo "Environment variables are all set"

