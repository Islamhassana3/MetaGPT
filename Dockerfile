# Use a base image with Python3.9 and Nodejs20 slim version
FROM nikolaik/python-nodejs:python3.9-nodejs20-slim
# Install Debian software needed by MetaGPT and clean up in one RUN command to reduce image size
RUN apt update &&\
    apt install -y libgomp1 git chromium fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-freefont-ttf libxss1 --no-install-recommends file &&\
    apt clean && rm -rf /var/lib/apt/lists/*
# Install Mermaid CLI globally
ENV CHROME_BIN="/usr/bin/chromium" \
    puppeteer_config="/app/metagpt/config/puppeteer-config.json"\
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true"
RUN npm install -g @mermaid-js/mermaid-cli &&\
    npm cache clean --force
# Install Python dependencies and install MetaGPT
COPY . /app/metagpt
WORKDIR /app/metagpt
RUN mkdir -p workspace &&\
    pip install --no-cache-dir -r requirements.txt &&\
    pip install -e .

# Expose default port (actual port is set via PORT environment variable at runtime)
EXPOSE 8000

# Run the web server using gunicorn for production
# Use shell form to ensure proper variable expansion
CMD ["/bin/sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 1 --timeout 300 --pythonpath examples stream_output_via_api:app"]

