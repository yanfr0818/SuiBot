#!/bin/sh

# Start Event Bridge in the background
echo "Starting LAPLACE Event Bridge..."
/usr/local/bin/leb-server --host 0.0.0.0 --port 9696 &

# Wait for bridge to be ready (simple sleep)
sleep 2

# Start BiliBot
echo "Starting BiliBot..."

# Ensure config.yaml exists
if [ ! -f config.yaml ]; then
    echo "Creating config.yaml from config.example.yaml..."
    cp config.example.yaml config.yaml
fi

exec bun run start
