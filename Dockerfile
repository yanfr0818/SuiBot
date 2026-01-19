# Use Bun official image
FROM oven/bun:1 AS base
WORKDIR /app

# Install dependencies
FROM base AS install
COPY package.json ./
RUN bun install --production

# Copy source code
FROM base AS release
COPY --from=install /app/node_modules ./node_modules
COPY . .

# Download Event Bridge Server binary
# We use the Go binary for better performance and stability
ADD https://github.com/laplace-live/event-bridge/releases/latest/download/leb-server-linux-amd64 /usr/local/bin/leb-server
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
