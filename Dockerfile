FROM n8nio/n8n:1.120.4

USER root

# Install npm package manager dependencies required at startup
RUN mkdir -p /opt/n8n-custom-nodes

# Create startup script
RUN cat > /opt/n8n-custom-nodes/start.sh <<'EOF'
#!/bin/sh
set -e

N8N_NODES_DIR="/home/node/.n8n/nodes"

mkdir -p "$N8N_NODES_DIR"

cd "$N8N_NODES_DIR"

# Create package.json if it doesn't exist
if [ ! -f package.json ]; then
    cat > package.json <<'JSON'
{
  "name": "installed-nodes",
  "private": true
}
JSON
fi

# Install Qdrant if it isn't already installed
if [ ! -d "node_modules/n8n-nodes-qdrant" ]; then
    echo "Installing n8n-nodes-qdrant@0.2.1..."
    npm install n8n-nodes-qdrant@0.2.1
else
    echo "n8n-nodes-qdrant already installed."
fi

exec /docker-entrypoint.sh
EOF

RUN chmod +x /opt/n8n-custom-nodes/start.sh \
    && chown -R node:node /opt/n8n-custom-nodes

USER node

ENTRYPOINT ["/opt/n8n-custom-nodes/start.sh"]
