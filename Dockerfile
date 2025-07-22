# Start from the official n8n image.
FROM n8nio/n8n:latest

# Switch to the root user to install packages
USER root

#
# === STEP 1: Install System Packages via APK ===
#
# Install all dependencies needed for both TeX Live and WeasyPrint.
#
RUN apk add --no-cache \
    pandoc \
    texlive-full \
    curl \
    fontconfig \
    ttf-freefont \
    unzip \
    # Dependencies for WeasyPrint
    python3 \
    py3-pip \
    pango-dev \
    cairo-dev \
gdk-pixbuf-dev \
    build-base

#
# === STEP 2: Install Python Packages via PIP ===
#
# Now, install WeasyPrint using pip.
# We add --break-system-packages to override the "externally-managed-environment" error.
#
RUN pip3 install --no-cache-dir --break-system-packages WeasyPrint

#
# === STEP 3: Install Custom Fonts and Build Font Cache ===
#
# Your original custom font installation and caching logic is perfect.
#
RUN curl -L -o /usr/share/fonts/truetype/ComicNeue-Regular.ttf https://raw.githubusercontent.com/google/fonts/main/ofl/comicneue/ComicNeue-Regular.ttf && \
    fc-cache -f -v

# =================================================================
# === STEP 4: Copy Styling Files ===
# =================================================================
COPY style.css /data/
COPY storybook_style.css /data/
COPY template.tex /data/
COPY storybook_template.tex /data/
# =================================================================

# =================================================================
# === STEP 5: Set Correct Directory Permissions ===
# =================================================================
RUN chown -R node:node /data

# Switch back to the non-root node user for security
USER node
