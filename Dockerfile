FROM n8nio/n8n:1.120.4

USER root

# ================================================================
# Install Qdrant community node
# ================================================================
RUN mkdir -p /opt/n8n-custom-nodes \
    && cd /opt/n8n-custom-nodes \
    && npm pack n8n-nodes-qdrant@0.2.1 \
    && tar -xzf n8n-nodes-qdrant-0.2.1.tgz \
    && mv package n8n-nodes-qdrant \
    && rm n8n-nodes-qdrant-0.2.1.tgz

# Ensure n8n can read the custom node
RUN chown -R node:node /opt/n8n-custom-nodes

# Point n8n directly at the custom node directory
ENV N8N_CUSTOM_EXTENSIONS=/opt/n8n-custom-nodes/n8n-nodes-qdrant

USER node
