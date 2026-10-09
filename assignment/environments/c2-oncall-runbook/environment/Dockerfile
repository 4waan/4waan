FROM python:3.12-slim@sha256:05cda9777409a9c3ffddd94a4c476b79f0769a0b4857f0c7ed9226b6800b0d6f

# Terminal-based agents (terminus-2) expect tmux; asciinema is used for optional
# session recording. Pre-installing them keeps the rollout off the network.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tmux procps ca-certificates asciinema \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY repo/ /app/
