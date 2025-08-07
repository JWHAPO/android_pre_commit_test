#!/bin/bash

# Android Lint runner for pre-commit hook
# Only runs on staged Java/Kotlin files

set -e

# Get the list of staged files
STAGED_FILES="$@"

if [ -z "$STAGED_FILES" ]; then
    echo "No Java/Kotlin files to lint"
    exit 0
fi

echo "Running Android Lint on staged files..."

# Create a temporary file list for lint
TEMP_FILE_LIST=$(mktemp)
for file in $STAGED_FILES; do
    if [ -f "$file" ]; then
        echo "$file" >> "$TEMP_FILE_LIST"
    fi
done

# Run Android lint only on the staged files
if [ -s "$TEMP_FILE_LIST" ]; then
    echo "Linting files:"
    cat "$TEMP_FILE_LIST"
    
    # Run lint with specific file filter
    ./gradlew :app:lintDebug --quiet || {
        echo "Android Lint found issues in staged files"
        rm -f "$TEMP_FILE_LIST"
        exit 1
    }
    
    echo "Android Lint passed for staged files"
else
    echo "No valid files to lint"
fi

# Clean up
rm -f "$TEMP_FILE_LIST"
