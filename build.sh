#!/bin/bash

set -e

echo "================================"
echo " Docker Compose Image Build"
echo "================================"

# Build Docker image using Compose
docker compose -f docker-compose.yml build
sleep (3)
echo "================================"
echo " Docker image build completed"
echo "================================"

# Display available images
docker images
sleep(2)