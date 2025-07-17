FROM n8nio/n8n:latest

USER root

# Install Pandoc and minimal LaTeX
RUN apt-get update && \
    apt-get install -y pandoc texlive texlive-xetex fonts-freefont-ttf unzip curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Optional: Add some fun fonts like Comic Sans or Google Fonts
RUN mkdir -p /usr/share/fonts/truetype/custom && \
    curl -L -o /usr/share/fonts/truetype/custom/ComicNeue-Regular.ttf https://github.com/crozynski/comicneue/raw/master/TTF/ComicNeue-Regular.ttf && \
    fc-cache -f -v

USER node
