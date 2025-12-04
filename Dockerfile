FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Install required packages including uv
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y --no-install-recommends ffmpeg wireless-tools curl unzip && \
    apt-get clean && \
    curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh -s -- -y && \
    rm -rf /var/lib/apt/lists/*

# Add uv to PATH
ENV PATH="/root/.cargo/bin:$PATH"

WORKDIR /app

# Copy all required files into the image
COPY pyproject.toml ./
COPY docs ./docs
COPY pikaraoke ./pikaraoke

# Install dependencies with uv (much faster than poetry)
RUN uv pip install --system -e .

ENTRYPOINT ["pikaraoke", "-d", "/app/pikaraoke-songs/", "--headless"]
