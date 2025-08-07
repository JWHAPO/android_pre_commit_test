#!/bin/bash

# Git hooks setup script for Android project

set -e

echo "Setting up Git hooks for Android project..."

# Get the root directory of the git repository
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

# Create scripts directory if it doesn't exist
mkdir -p scripts

# Make all scripts executable
chmod +x scripts/*.sh

# Ensure .git/hooks directory exists
mkdir -p .git/hooks

# Check if pre-commit hook exists, if not create it
if [ ! -f ".git/hooks/pre-commit" ]; then
    echo "Creating .git/hooks/pre-commit file..."
    touch .git/hooks/pre-commit
    echo "#!/bin/bash" >> .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
fi

# Make the git hook executable
chmod +x .git/hooks/pre-commit

# Verify the hook is now executable
if [ -x ".git/hooks/pre-commit" ]; then
    echo "✅ Git hook is now executable"
else
    echo "❌ Failed to make git hook executable"
    exit 1
fi

echo "✅ Git hooks setup completed successfully!"
echo ""
echo "Usage:"
echo "  - Hooks will run automatically on 'git commit'"
echo "  - To bypass hooks temporarily: 'git commit --no-verify'"
echo ""
echo "The following checks will run before each commit:"
echo "  🐛 Debug code detection (Log, Trace, System.out, etc.)"
echo "  📋 Checkstyle (Java files)"
echo "  🔍 Kotlin Lint (Kotlin files)"  
echo "  🔍 Android Lint (Java/Kotlin files)"
echo ""
echo "Only staged files will be checked, not the entire codebase."
echo ""
echo "Test the setup by making a commit!"
