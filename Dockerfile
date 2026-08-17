FROM n8nio/n8n:1.120.4

USER root

RUN mkdir -p /opt/n8n-custom-nodes \
    && npm install --prefix /opt/n8n-custom-nodes \
       n8n-nodes-qdrant@0.2.1

RUN chown -R node:node /opt/n8n-custom-nodes

ENV N8N_CUSTOM_EXTENSIONS=/opt/n8n-custom-nodes/node_modules

USER node
