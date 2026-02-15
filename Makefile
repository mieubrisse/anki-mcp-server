.PHONY: build clean install test publish publish-dry-run docker-build help

# Docker image name
IMAGE_NAME := anki-mcp-server-builder
CONTAINER_NAME := anki-mcp-server-build

# Help target
help:
	@echo "Available targets:"
	@echo "  make build           - Build the project using Docker"
	@echo "  make install         - Install dependencies using Docker"
	@echo "  make clean           - Remove build artifacts and Docker containers"
	@echo "  make publish-dry-run - Test npm publish (dry run) using Docker"
	@echo "  make publish         - Publish to npm using Docker (requires NPM_TOKEN)"
	@echo "  make docker-build    - Build the Docker image"
	@echo "  make help            - Show this help message"

# Build the Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME) .

# Install dependencies
install: docker-build
	@echo "Installing dependencies..."
	docker run --rm \
		-v "$(PWD)":/app \
		-w /app \
		$(IMAGE_NAME) \
		npm install

# Build the project
build: docker-build
	@echo "Building project..."
	docker run --rm \
		-v "$(PWD)":/app \
		-w /app \
		$(IMAGE_NAME) \
		sh -c "npm install && npm run build"
	@echo "Build complete! Output in ./build/"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf build/
	rm -rf node_modules/
	docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	@echo "Clean complete!"

# Dry run publish (test without actually publishing)
publish-dry-run: docker-build
	@echo "Running publish dry-run..."
	docker run --rm \
		-v "$(PWD)":/app \
		-w /app \
		$(IMAGE_NAME) \
		sh -c "npm install && npm run build && npm publish --dry-run"

# Publish to npm (requires NPM_TOKEN environment variable)
publish: docker-build
	@if [ -z "$(NPM_TOKEN)" ]; then \
		echo "Error: NPM_TOKEN environment variable is not set"; \
		echo "Usage: NPM_TOKEN=your-token make publish"; \
		exit 1; \
	fi
	@echo "Publishing to npm..."
	docker run --rm \
		-v "$(PWD)":/app \
		-w /app \
		-e NPM_TOKEN=$(NPM_TOKEN) \
		$(IMAGE_NAME) \
		sh -c "echo '//registry.npmjs.org/:_authToken=$(NPM_TOKEN)' > ~/.npmrc && \
		       npm install && \
		       npm run build && \
		       npm publish --access public"
	@echo "Published successfully!"
