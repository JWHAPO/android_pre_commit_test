#!/bin/bash

# Pre-commit setup script for Android project

set -e

echo "Setting up pre-commit hooks for Android project..."

# Create scripts directory if it doesn't exist
mkdir -p scripts

# Make all scripts executable
chmod +x scripts/*.sh

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "Installing pre-commit..."
    
    # Try to install via pip
    if command -v pip3 &> /dev/null; then
        pip3 install pre-commit
    elif command -v pip &> /dev/null; then
        pip install pre-commit
    else
        echo "Error: pip not found. Please install pre-commit manually:"
        echo "  pip install pre-commit"
        exit 1
    fi
fi

# Install pre-commit hooks
echo "Installing pre-commit hooks..."
pre-commit install

# Run pre-commit on all files to test setup
echo "Testing pre-commit setup..."
pre-commit run --all-files || {
    echo "Pre-commit setup completed with some issues."
    echo "This is normal for the first run. The hooks are now installed."
    exit 0
}

echo "✅ Pre-commit setup completed successfully!"
echo ""
echo "Usage:"
echo "  - Hooks will run automatically on 'git commit'"
echo "  - To run manually: 'pre-commit run --all-files'"
echo "  - To run on staged files: 'pre-commit run'"
echo ""
echo "The following checks will run before each commit:"
echo "  ✓ Checkstyle (Java files)"
echo "  ✓ Android Lint (Java/Kotlin files)"
echo "  ✓ Kotlin Lint (Kotlin files)"
echo "  ✓ Debug code detection (Java/Kotlin files)"
echo "  ✓ Basic file checks (trailing whitespace, etc.)"
