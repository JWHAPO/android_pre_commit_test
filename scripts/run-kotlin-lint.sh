#!/bin/bash

# Kotlin Lint (ktlint) runner for pre-commit hook
# Only runs on staged Kotlin files

set -e

# Get the list of staged Kotlin files
STAGED_FILES="$@"

if [ -z "$STAGED_FILES" ]; then
    echo "No Kotlin files to lint"
    exit 0
fi

echo "Running Kotlin Lint on staged files..."

# Check if ktlint is available
if ! command -v ktlint &> /dev/null; then
    echo "ktlint not found. Trying to run via Gradle..."
    
    # Check if ktlint is configured in Gradle
    if ./gradlew tasks --all | grep -q "ktlint"; then
        ./gradlew ktlintCheck --quiet || {
            echo "Kotlin Lint found issues in staged files"
            exit 1
        }
    else
        echo "Warning: ktlint not configured. Skipping Kotlin lint check."
        echo "To enable ktlint, add the ktlint plugin to your build.gradle"
        exit 0
    fi
else
    # Run ktlint on each staged Kotlin file
    for file in $STAGED_FILES; do
        if [ -f "$file" ]; then
            echo "Linting: $file"
            ktlint "$file" || {
                echo "Kotlin Lint failed for $file"
                exit 1
            }
        fi
    done
fi

echo "Kotlin Lint passed for all staged Kotlin files"
