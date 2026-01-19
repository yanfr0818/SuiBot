#!/bin/sh

# Start Event Bridge in the background
echo "Starting LAPLACE Event Bridge..."
/usr/local/bin/leb-server --host 0.0.0.0 --port 9696 &

# Wait for bridge to be ready (simple sleep)
sleep 2

# Start BiliBot
echo "Starting BiliBot..."

# Ensure config.yaml exists and inject environment variables
if [ ! -f config.yaml ]; then
    echo "Creating config.yaml from config.example.yaml..."
    cp config.example.yaml config.yaml
fi

# Inject environment variables into config.yaml
echo "Injecting environment variables into config.yaml..."
sed -i "s/\${ROOM_ID}/${ROOM_ID}/g" config.yaml
sed -i "s/\${UID}/${UID}/g" config.yaml
sed -i "s/\${SLUG}/${SLUG}/g" config.yaml
sed -i "s/\${TELEGRAM_ANNOUNCE_CH}/${TELEGRAM_ANNOUNCE_CH}/g" config.yaml
sed -i "s/\${TELEGRAM_WATCHERS_CH}/${TELEGRAM_WATCHERS_CH}/g" config.yaml

exec bun run start
