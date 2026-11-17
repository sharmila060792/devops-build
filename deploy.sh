
#!/bin/bash

set -e

echo "===================================="
echo " Starting Docker Application Deploy"
echo "===================================="

# Check Docker availability
if ! docker info > /dev/null 2>&1; then
    echo "ERROR: Docker is not running"
    exit 1
fi

# Check Compose file
if [ ! -f docker-compose.yml ]; then
    echo "ERROR: docker-compose.yml not found"
    exit 1
fi

# Build and deploy application
#echo "Building Docker image..."

#docker compose -f compose.yaml build

echo "Starting application..."

docker compose -f docker-compose.yml up -d

# Display container status
echo "Checking application status..."

docker compose -f docker-compose.yml ps

echo "===================================="
echo " Deployment completed successfully"
echo "===================================="
