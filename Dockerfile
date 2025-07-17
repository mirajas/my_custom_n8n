# Start from the official n8n image. Using a specific version is highly recommended
# to avoid unexpected breaking changes. Find your version in the n8n UI.
# Example: FROM n8nio/n8n:1.46.0
FROM n8nio/n8n:latest

# Switch to the root user to install packages
USER root

# The official n8n image is based on Alpine Linux, which uses the 'apk' package manager.
# We must use 'apk' instead of 'apt-get'.
# We also need 'fontconfig' to make the 'fc-cache' command available later.
# The --no-cache flag is the standard way to install packages in Alpine to keep the image small.
RUN apk add --no-cache \
    pandoc \
    texlive \
    texlive-xetex \
    ttf-freefont \
    unzip \
    curl \
    fontconfig

# This part is fine, but it depends on curl and fontconfig from the step above.
# Create a directory for custom fonts
RUN mkdir -p /usr/share/fonts/truetype/custom && \
    # Download the Comic Neue font
    curl -L -o /usr/share/fonts/truetype/custom/ComicNeue-Regular.ttf https://github.com/crozynski/comicneue/raw/master/TTF/ComicNeue-Regular.ttf && \
    # Rebuild the font cache to include the new font
    fc-cache -f -v

# Switch back to the non-root node user for security
USER node
