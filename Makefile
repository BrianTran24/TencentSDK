# Makefile for Tencent Cloud Chat SDK

.PHONY: help build-web clean test install-deps

# Default target
help:
	@echo "Tencent Cloud Chat SDK - Build Commands"
	@echo ""
	@echo "Available targets:"
	@echo "  make build-web      - Build the demo for web platform"
	@echo "  make install-deps   - Install all dependencies (Flutter + npm)"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make test           - Run tests"
	@echo "  make help           - Show this help message"
	@echo ""

# Build for web
build-web:
	@echo "Building for web..."
	@cd imdemo/web && npm install
	@cd imdemo && flutter pub get
	@cd imdemo && flutter build web --release
	@echo "Build complete! Output: imdemo/build/web/"

# Install dependencies
install-deps:
	@echo "Installing dependencies..."
	@cd imdemo/web && npm install
	@cd imdemo && flutter pub get
	@echo "Dependencies installed!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@cd imdemo && flutter clean
	@rm -rf imdemo/build
	@echo "Clean complete!"

# Run tests
test:
	@echo "Running tests..."
	@cd imdemo && flutter test
	@echo "Tests complete!"
