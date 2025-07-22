# Start from the official n8n image.
FROM n8nio/n8n:latest

# Switch to the root user to install packages
USER root

#
# === COMBINED PACKAGE INSTALLATION ===
#
# This single command installs:
# 1. Your original packages (Pandoc, TeX Live, fonts, etc.)
# 2. The new dependencies needed for WeasyPrint on Alpine Linux.
# 3. WeasyPrint itself via pip.
#
RUN apk add --no-cache \
    pandoc \
    texlive-full \
    curl \
    fontconfig \
    ttf-freefont \
    unzip \
    # ---- ADDED FOR WEASYPRINT ----
    python3 \
    py3-pip \
    pango-dev \
    cairo-dev \
    gdk-pixbuf-dev \
    build-base \
# ---- INSTALL WEASYPRINT ITSELF ----
&& pip3 install WeasyPrint

# Your original custom font installation (no changes needed).
RUN mkdir -p /usr/share/fonts/truetype/custom && \
    curl -L -o /usr/share/fonts/truetype/custom/ComicNeue-Regular.ttf https://github.com/crozynski/comicneue/raw/master/TTF/ComicNeue-Regular.ttf && \
    fc-cache -f -v

# =================================================================
# === COPY YOUR STYLING FILES (No changes needed) ===
# =================================================================
# Both files are kept so both workflows can use their respective templates.
COPY style.css /data/
COPY template.tex /data/
# =================================================================

# =================================================================
# === PERMISSION FIX (No changes needed) ===
# =================================================================
RUN chown -R node:node /data

# Switch back to the non-root node user for security
USER node
