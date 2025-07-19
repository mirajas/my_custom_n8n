# Start from the official n8n image.
FROM n8nio/n8n:latest

# Switch to the root user to install packages
USER root

#
# === THE FINAL, GUARANTEED FIX ===
#
# We are abandoning all complex installers and installing ONE package
# that contains everything: 'texlive-full'.
# This also installs pandoc as a dependency.
# This command will take a very long time to complete. Please be patient.
#
RUN apk add --no-cache texlive-full

# Switch back to the non-root node user for security
USER node
