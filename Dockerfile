# Start from the official n8n image.
FROM n8nio/n8n:latest

# Switch to the root user to install packages and run the installer
USER root

# =========== THE FINAL FIX: A FULL TEX LIVE INSTALLATION ===========

# Step 1: Install base dependencies including Pandoc and Perl
RUN apk add --no-cache \
    pandoc \
    perl \
    wget \
    fontconfig \
    ttf-freefont \
    unzip \
    curl

# Step 2: Download the TeX Live installer
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

# Step 3: Unpack the installer
RUN tar -xzf install-tl-unx.tar.gz

# Step 4: Run the TeX Live installer.
#
# THE FIX IS HERE: We move into the correct directory and run the installer
# in a single, chained command. We use a wildcard (*) to match whatever
# date-stamped directory the tarball creates. This makes the script robust.
#
RUN cd install-tl-*/ && ./install-tl -profile=texlive.profile

# Step 5: Add the new TeX Live binaries to the system's PATH.
# We use a wildcard again to make sure we get the correct year.
ENV PATH="/usr/local/texlive/20*/bin/x86_64-linuxmusl:${PATH}"

# Step 6: Clean up the installer files.
RUN rm -rf /install-tl-*


# =========== YOUR CUSTOM FONT INSTALLATION (This part is fine) ===========

RUN mkdir -p /usr/share/fonts/truetype/custom && \
    curl -L -o /usr/share/fonts/truetype/custom/ComicNeue-Regular.ttf https://github.com/crozynski/comicneue/raw/master/TTF/ComicNeue-Regular.ttf && \
    fc-cache -f -v

# Switch back to the non-root node user for security
USER node
