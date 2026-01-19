# Use Bun official image
FROM oven/bun:1 AS base
WORKDIR /app

# Install dependencies
FROM base AS install
COPY package.json ./
RUN bun install --production

# Build Event Bridge Server from source
# This avoids 403 (private image) and 404 (bad URL) errors
FROM golang:1.23-alpine AS bridge-builder
RUN apk add --no-cache git
WORKDIR /build
RUN git clone https://github.com/laplace-live/event-bridge.git .
WORKDIR /build/packages/server
RUN go build -o leb-server .

# Main image
FROM base AS release
COPY --from=install /app/node_modules ./node_modules
COPY . .

# Copy binary from builder
COPY --from=bridge-builder /build/packages/server/leb-server /usr/local/bin/leb-server
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
