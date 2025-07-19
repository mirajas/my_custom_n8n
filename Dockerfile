# Start from the official n8n image.
FROM n8nio/n8n:latest

# Switch to the root user to install packages and run the installer
USER root

# =========== THE FINAL FIX: A FULL TEX LIVE INSTALLATION ===========

# Step 1: Install base dependencies including Pandoc and Perl (required by the TeX Live installer)
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
# This is a non-interactive installation of a small, working scheme.
# It installs all the essential packages, including xcolor and the base fonts.
# This command will take several minutes to run.
WORKDIR /install-tl-20240701
# The directory name might change slightly based on download date, adjust if needed
RUN ./install-tl --profile=/install-tl-20240701/texlive.profile

# Step 5: Add the new TeX Live binaries to the system's PATH.
# This is crucial so that Pandoc and the shell can find the `pdflatex` command.
ENV PATH="/usr/local/texlive/2024/bin/x86_64-linuxmusl:${PATH}"

# Step 6: Clean up the installer files to keep the image size down.
RUN rm -rf /install-tl-20240701 /install-tl-unx.tar.gz


# =========== YOUR CUSTOM FONT INSTALLATION (This part is fine) ===========

RUN mkdir -p /usr/share/fonts/truetype/custom && \
    curl -L -o /usr/share/fonts/truetype/custom/ComicNeue-Regular.ttf https://github.com/crozynski/comicneue/raw/master/TTF/ComicNeue-Regular.ttf && \
    fc-cache -f -v

# Switch back to the non-root node user for security
USER node
