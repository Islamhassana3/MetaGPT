#!/bin/bash
# Start script for MetaGPT API server on Railway.app

# Set default port if not provided
export PORT=${PORT:-8000}

# Run the server with gunicorn
gunicorn --bind 0.0.0.0:$PORT \
    --workers 1 \
    --timeout 300 \
    --pythonpath examples \
    stream_output_via_api:app
