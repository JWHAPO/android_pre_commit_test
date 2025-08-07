#!/bin/bash

# Checkstyle runner for pre-commit hook
# Only runs on staged Java files

set -e

# Check if checkstyle is available
if ! command -v checkstyle &> /dev/null; then
    echo "Checkstyle not found. Installing via Gradle..."
    ./gradlew checkstyleMain --quiet || {
        echo "Failed to run checkstyle via Gradle"
        exit 1
    }
    exit 0
fi

# Get the list of staged Java files
STAGED_FILES="$@"

if [ -z "$STAGED_FILES" ]; then
    echo "No Java files to check"
    exit 0
fi

echo "Running Checkstyle on staged files..."

# Run checkstyle on each staged file
for file in $STAGED_FILES; do
    if [ -f "$file" ]; then
        echo "Checking: $file"
        checkstyle -c tools/sun_checks.xml "$file" || {
            echo "Checkstyle failed for $file"
            exit 1
        }
    fi
done

echo "Checkstyle passed for all staged Java files"
