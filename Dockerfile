FROM n8nio/n8n:1.120.4

USER root

# ================================================================
# Install Qdrant community node into the image
# ================================================================
RUN mkdir -p /opt/n8n-custom-nodes \
    && npm install --prefix /opt/n8n-custom-nodes \
       n8n-nodes-qdrant@0.2.1

# Make the custom node readable by n8n
RUN chown -R node:node /opt/n8n-custom-nodes

# Tell n8n where community nodes are installed
ENV N8N_CUSTOM_EXTENSIONS=/opt/n8n-custom-nodes/node_modules

USER node
