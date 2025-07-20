# Start from the official n8n image.
FROM n8nio/n8n:latest

# Switch to the root user to install packages
USER root

#
# === THE FINAL, DEFINITIVE FIX ===
#
# This single command installs BOTH Pandoc itself AND the complete TeX Live suite.
# This ensures all dependencies for EPUB and PDF creation are present.
# This build will take a long time. Please be patient.
#
RUN apk add --no-cache \
    pandoc \
    texlive-full \
    curl \
    fontconfig \
    ttf-freefont \
    unzip

# Your original custom font installation, which is good to keep.
RUN mkdir -p /usr/share/fonts/truetype/custom && \
    curl -L -o /usr/share/fonts/truetype/custom/ComicNeue-Regular.ttf https://github.com/crozynski/comicneue/raw/master/TTF/ComicNeue-Regular.ttf && \
    fc-cache -f -v

# =================================================================
# === NEW SECTION: COPY YOUR STYLING FILES INTO THE CONTAINER ===
# =================================================================
# The n8n execution directory is /data. We copy our files there.
COPY style.css /data/
COPY header.tex /data/
# =================================================================

# Switch back to the non-root node user for security
USER node
