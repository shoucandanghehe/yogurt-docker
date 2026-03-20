FROM debian:stable-slim

# Yogurt version (update as needed)
ARG YOGURT_VERSION=v0.1.0-dev.181
ARG YOGURT_REPO=SaltifyDev/yogurt-releases
ARG YOGURT_ARCH=linux-x64

# Download and extract yogurt from GitHub releases
RUN apt-get update && apt-get install -y --no-install-recommends curl unzip ca-certificates adduser \
    && mkdir -p /app \
    && curl -fsSL "https://github.com/${YOGURT_REPO}/releases/download/${YOGURT_VERSION}/yogurt-${YOGURT_ARCH}.zip" -o "/tmp/yogurt.zip" \
    && [ -s "/tmp/yogurt.zip" ] || (echo "Error: zip file is empty or missing" && exit 1) \
    && YOGURT_BIN=$(unzip -l "/tmp/yogurt.zip" | grep -E 'yogurt\.kexe|yogurt$' | head -1 | awk '{print $4}') \
    && [ -n "$YOGURT_BIN" ] || (echo "Error: yogurt binary not found in zip" && exit 1) \
    && unzip -j "/tmp/yogurt.zip" "$YOGURT_BIN" -d /app \
    && mv /app/$(basename "$YOGURT_BIN") /app/yogurt \
    && rm /tmp/yogurt.zip \
    && chmod +x /app/yogurt \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN groupadd -g 1000 yogurt && adduser --disabled-login --gecos '' --uid 1000 --gid 1000 yogurt

WORKDIR /app

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Create data directory with proper permissions
RUN mkdir -p /app/data && chown -R yogurt:yogurt /app

# Switch to non-root user
USER yogurt

# Expose HTTP port (default 3000)
EXPOSE 3000

# Volume for persistent data
VOLUME ["/app/data"]

ENV YOGURT_DATA_DIR=/app/data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/app/yogurt"]
