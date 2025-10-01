# Railway.app Deployment Guide

This guide explains how to deploy MetaGPT on Railway.app.

## Prerequisites

1. A Railway.app account
2. Your OpenAI API key or other LLM provider credentials

## Deployment Steps

### Method 1: Using Railway CLI

1. Install Railway CLI:
```bash
npm install -g @railway/cli
```

2. Login to Railway:
```bash
railway login
```

3. Initialize your project:
```bash
railway init
```

4. Add environment variables:
```bash
railway variables set OPENAI_API_KEY=your_api_key_here
```

5. Deploy:
```bash
railway up
```

### Method 2: Deploy from GitHub

1. Fork or clone this repository to your GitHub account
2. Go to [Railway.app](https://railway.app)
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Choose this repository
6. Add the following environment variables in Railway dashboard:
   - `OPENAI_API_KEY` - Your OpenAI API key
   - `PORT` - (Optional, Railway sets this automatically)

### Method 3: Deploy with Railway Button

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

## Environment Variables

Required environment variables:
- `OPENAI_API_KEY` - Your OpenAI API key (or appropriate LLM provider key)

Optional environment variables:
- `PORT` - Server port (Railway sets this automatically, default: 8000)
- `METAGPT_REPORTER_URL` - Custom reporter URL if needed

## Configuration

The deployment uses the following files:
- `Procfile` - Defines the web process
- `railway.json` - Railway-specific configuration
- `nixpacks.toml` - Build configuration for Nixpacks
- `requirements.txt` - Python dependencies

## Health Check

The application includes a health check endpoint at `/health` that Railway uses to verify the deployment is successful.

## API Endpoints

- `GET /` - Root endpoint with API information
- `GET /health` - Health check endpoint
- `POST /v1/chat/completions` - Main API endpoint for streaming tutorial generation
- `GET /download/<filename>` - Download generated files

## Testing the Deployment

After deployment, you can test the API with:

```bash
curl https://your-app.railway.app/health
```

To use the main API endpoint:

```bash
curl https://your-app.railway.app/v1/chat/completions -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "model": "write_tutorial",
    "stream": true,
    "messages": [
      {
        "role": "user",
        "content": "Write a tutorial about MySQL"
      }
    ]
  }'
```

## Troubleshooting

### Application failed to respond
- Check that your environment variables are set correctly
- Verify that the PORT environment variable is being used
- Check the deployment logs in Railway dashboard
- Ensure the health check endpoint `/health` is responding

### Build failures
- Verify that all dependencies in `requirements.txt` are available
- Check that Python 3.9 is being used
- Review build logs for specific error messages

### Memory issues
- Consider upgrading your Railway plan for more memory
- Reduce the number of workers in the Procfile if needed

## Local Testing

To test the deployment configuration locally:

```bash
# Install dependencies
pip install -r requirements.txt
pip install -e .

# Set environment variables
export PORT=8000
export OPENAI_API_KEY=your_api_key

# Run with gunicorn (production-like)
gunicorn --bind 0.0.0.0:8000 --workers 1 --timeout 300 --pythonpath examples stream_output_via_api:app

# Or run with Flask development server
python examples/stream_output_via_api.py
```

## Support

For Railway-specific issues, refer to:
- [Railway Documentation](https://docs.railway.app/)
- [Railway Help Station](https://help.railway.app/)

For MetaGPT issues:
- [MetaGPT Documentation](https://docs.deepwisdom.ai/)
- [MetaGPT GitHub Issues](https://github.com/geekan/MetaGPT/issues)
