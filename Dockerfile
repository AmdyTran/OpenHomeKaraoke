FROM python:3.12-slim

# Install required packages including uv
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y --no-install-recommends ffmpeg wireless-tools curl unzip && \
    apt-get clean && \
    curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh -s -- -y && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    rm -rf /var/lib/apt/lists/*

# Add uv to PATH
ENV PATH="/root/.cargo/bin:$PATH"

WORKDIR /app

# Copy minimum required files into the image
COPY pyproject.toml ./
COPY docs ./docs

# Install dependencies with uv (much faster than poetry)
RUN uv pip install --system -e .

# Copy the rest of the files
COPY pikaraoke ./pikaraoke

ENTRYPOINT ["python", "-m", "pikaraoke", "-d", "/app/pikaraoke-songs/", "--headless"]
