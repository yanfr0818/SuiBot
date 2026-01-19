# Use Bun official image
FROM oven/bun:1 AS base
WORKDIR /app

# Install dependencies
FROM base AS install
COPY package.json ./
RUN bun install --production

# Get Event Bridge Server binary from official image
FROM ghcr.io/laplace-live/event-bridge:latest AS bridge-source

# Main image
FROM base AS release
COPY --from=install /app/node_modules ./node_modules
COPY . .

# Copy binary from official image
COPY --from=bridge-source /usr/local/bin/leb-server /usr/local/bin/leb-server
# Fallback: If it's not in /usr/local/bin, try /app/leb-server (commented out as logic needs to be precise)
# We assume standard path. If this fails, we will check the image structure.
RUN chmod +x /usr/local/bin/leb-server

# Create bot-data directory
RUN mkdir -p bot-data

# Copy start script
COPY start.sh .
RUN chmod +x start.sh

# Expose ports
# 3000: Web health check (optional)
# 9696: Event Bridge WebSocket
EXPOSE 3000 9696

# Run the start script
CMD ["./start.sh"]
