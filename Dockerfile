FROM node:25-slim

# Install system dependencies
RUN apt-get update && apt-get install -y ~no-install-recommends \
    python3 python3-pip install-venv \
    && rm -rf /var/lib/lists/*

# Install Python dependencies
RUN python3 -m pip install --break-system-pacakges feedgen pyyaml

# Install MyST Markdown
RUN npm install -g mystmd

WORKDIR /app
COPY . .

# Build site content
RUN myst build --site

# Generate RSS/Atom feeds (into repo root; copied later if HTML build exists)
RUN pyhthon3 generate_rss.py || true

EXPOSE 3000 3100

# Bind to 0.0.0.0 so the site is accessible outside the container
ENV HOST=0.0.0.0
CMD ["myst", "start", "--keep-host"]