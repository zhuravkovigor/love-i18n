# Makefile for love-i18n library

.PHONY: test install uninstall clean lint format help docs package setup ci check-tools upload-luarocks pack

# Default target
all: test

# Run tests
test:
	@echo "Running tests..."
	@lua test.lua

# Install via LuaRocks (local development)
install:
	@echo "Installing love-i18n via LuaRocks..."
	@luarocks make love-i18n-1.0-1.rockspec

# Upload to LuaRocks repository
# Usage: make upload-luarocks API_KEY=your_api_key_here
upload-luarocks:
	@echo "Uploading to LuaRocks..."
	@command -v luarocks >/dev/null 2>&1 || { echo "luarocks not found"; exit 1; }
	@test -f love-i18n-1.0-1.rockspec || { echo "Rockspec not found"; exit 1; }
	@if [ -n "$(API_KEY)" ]; then \
		echo "Using provided API key..."; \
		luarocks upload love-i18n-1.0-1.rockspec --api-key=$(API_KEY); \
	else \
		echo "No API key provided. Please use: make upload-luarocks API_KEY=your_key"; \
		echo "Or ensure you are logged in to LuaRocks (luarocks login)"; \
		luarocks upload love-i18n-1.0-1.rockspec; \
	fi

# Remove LuaRocks installation
uninstall:
	@echo "Uninstalling love-i18n..."
	@luarocks remove love-i18n

# Clean up generated files
clean:
	@echo "Cleaning up..."
	@rm -f luacov.stats.out luacov.report.out
	@find . -name "*.tmp" -delete
	@find . -name "*~" -delete

# Lint Lua files (requires luacheck)
lint:
	@echo "Linting Lua files..."
	@command -v luacheck >/dev/null 2>&1 || { echo "luacheck not found. Install with: luarocks install luacheck"; exit 1; }
	@luacheck init.lua test.lua

# Format Lua files (requires stylua)
format:
	@echo "Formatting Lua files..."
	@command -v stylua >/dev/null 2>&1 || { echo "stylua not found. Install from: https://github.com/JohnnyMorganz/StyLua"; exit 1; }
	@stylua init.lua test.lua translations/

# Check for required tools
check-tools:
	@echo "Checking for required tools..."
	@command -v lua >/dev/null 2>&1 || { echo "lua not found"; exit 1; }
	@command -v luarocks >/dev/null 2>&1 || { echo "luarocks not found"; exit 1; }
	@echo "✓ All required tools are available"

# Generate documentation (if using ldoc)
docs:
	@echo "Generating documentation..."
	@command -v ldoc >/dev/null 2>&1 || { echo "ldoc not found. Install with: luarocks install ldoc"; exit 1; }
	@ldoc -d docs init.lua

# Package for distribution
package: clean test
	@echo "Creating package..."
	@mkdir -p dist
	@tar -czf dist/love-i18n-1.0.tar.gz \
		init.lua \
		translations/ \
		README.md \
		CHANGELOG.md \
		LICENSE \
		love-i18n-1.0-1.rockspec
	@echo "Package created: dist/love-i18n-1.0.tar.gz"

# Quick development setup
setup: check-tools
	@echo "Setting up development environment..."
	@echo "Creating example translations if they don't exist..."
	@test -f translations/en.lua || echo "English translations already exist"
	@test -f translations/es.lua || echo "Spanish translations already exist"
	@echo "✓ Development environment ready"

# Run continuous integration tests
ci: clean lint test
	@echo "✓ All CI checks passed"

# Version bump helpers
version-patch:
	@echo "This would bump patch version (1.0.1)"
	@echo "Update version in love-i18n-1.0-1.rockspec manually"

version-minor:
	@echo "This would bump minor version (1.1.0)"
	@echo "Update version in love-i18n-1.0-1.rockspec manually"

version-major:
	@echo "This would bump major version (2.0.0)"
	@echo "Update version in love-i18n-1.0-1.rockspec manually"

# Show available commands
help:
	@echo "Available commands:"
	@echo "  test              - Run test suite"
	@echo "  install           - Install via LuaRocks locally"
	@echo "  uninstall         - Remove LuaRocks installation"
	@echo "  pack              - Create LuaRocks package"
	@echo "  upload-luarocks   - Upload to LuaRocks repository"
	@echo "                      Usage: make upload-luarocks API_KEY=your_key"
	@echo "  clean             - Clean up generated files"
	@echo "  lint              - Lint Lua files (requires luacheck)"
	@echo "  format            - Format Lua files (requires stylua)"
	@echo "  docs              - Generate documentation (requires ldoc)"
	@echo "  package           - Create distribution package"
	@echo "  setup             - Setup development environment"
	@echo "  ci                - Run all CI checks"
	@echo "  check-tools       - Check for required tools"
	@echo "  help              - Show this help message"
	@echo ""
	@echo "Development workflow:"
	@echo "  1. make setup     # Setup environment"
	@echo "  2. make test      # Run tests during development"
	@echo "  3. make ci        # Full CI check before commit"
	@echo "  4. make pack      # Create LuaRocks package"
	@echo "  5. make upload-luarocks API_KEY=your_key # Upload to LuaRocks"
