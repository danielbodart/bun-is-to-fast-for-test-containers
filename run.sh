#!/usr/bin/env bash

. commands.sh

bun install

DEFAULT_IMAGE="testcontainers/ryuk:0.11.0"
SLOW_IMAGE="slow-ryuk"

function kill_image() {
  CONTAINER_ID=$(docker ps -q --filter ancestor=${DEFAULT_IMAGE})
  if [ -n "$CONTAINER_ID" ]; then
    docker kill "$CONTAINER_ID"
  fi
}

echo "Ensure no Ryuk containers are running, so it fails to start"
kill_image
RYUK_CONTAINER_IMAGE=${DEFAULT_IMAGE} bun test --timeout=15000

echo "If we run a second time, it will work as ryuk is already running"
docker ps --filter ancestor=${DEFAULT_IMAGE}
RYUK_CONTAINER_IMAGE=${DEFAULT_IMAGE} bun test --timeout=15000

echo "Or is we use a custom image that sleeps for 5 seconds before it starts"
kill_image
docker rmi ${SLOW_IMAGE}
docker build -t ${SLOW_IMAGE} .
RYUK_CONTAINER_IMAGE=${SLOW_IMAGE} bun test --timeout=15000

