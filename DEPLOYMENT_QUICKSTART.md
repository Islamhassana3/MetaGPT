# Quick Deployment Guide

## Railway.app Deployment (Recommended)

### Quick Deploy Button
The easiest way to deploy:

1. Click: [![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)
2. Connect your GitHub account
3. Set `OPENAI_API_KEY` environment variable
4. Deploy!

### Manual Deployment from GitHub

1. **Fork this repository** to your GitHub account

2. **Create a new project on Railway.app**:
   - Go to https://railway.app
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your forked repository

3. **Set Environment Variables**:
   - Click on your deployed service
   - Go to "Variables" tab
   - Add: `OPENAI_API_KEY=your_api_key_here`

4. **Deploy**:
   - Railway will automatically detect the configuration files
   - The deployment will start automatically
   - Wait for the build and deployment to complete

### Verify Deployment

Once deployed, test your deployment:

```bash
# Replace YOUR_APP_URL with your Railway app URL
curl https://YOUR_APP_URL.railway.app/health

# Expected response:
{"status":"ok"}
```

### API Endpoints

- `GET /` - API information and available endpoints
- `GET /health` - Health check endpoint
- `POST /v1/chat/completions` - Main API endpoint for tutorial generation
- `GET /download/<filename>` - Download generated files

### Example API Call

```bash
curl https://YOUR_APP_URL.railway.app/v1/chat/completions \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "model": "write_tutorial",
    "stream": true,
    "messages": [{
      "role": "user",
      "content": "Write a tutorial about Python"
    }]
  }'
```

## Local Development

```bash
# Install dependencies
pip install -r requirements.txt
pip install -e .

# Set environment variables
export PORT=8000
export OPENAI_API_KEY=your_api_key

# Run development server
python examples/stream_output_via_api.py

# Or run with gunicorn (production-like)
gunicorn --bind 0.0.0.0:8000 --workers 1 --timeout 300 --pythonpath examples stream_output_via_api:app
```

## Docker Deployment

```bash
# Build the image
docker build -t metagpt-api .

# Run the container
docker run -p 8000:8000 -e PORT=8000 -e OPENAI_API_KEY=your_api_key metagpt-api
```

## Troubleshooting

### "Application failed to respond"
- Check that `OPENAI_API_KEY` is set in Railway variables
- Verify the health check endpoint is responding: `/health`
- Check Railway logs for errors

### Build Failures
- Ensure all dependencies are listed in `requirements.txt`
- Check that Python 3.9 is being used
- Review Railway build logs for specific errors

### Connection Timeouts
- The app uses a 300-second timeout for long-running operations
- Make sure Railway's timeout settings are appropriate
- Check that the PORT environment variable is being used correctly

## Support

- Railway Documentation: https://docs.railway.app/
- MetaGPT Documentation: https://docs.deepwisdom.ai/
- Full deployment guide: See [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md)
