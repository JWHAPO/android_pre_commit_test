#!/bin/bash

# Checkstyle runner for pre-commit hook
# Uses Gradle checkstyle task with tools/sun_checks.xml

set -e

# Get the list of staged Java files
STAGED_FILES="$@"

if [ -z "$STAGED_FILES" ]; then
    echo "No Java files to check"
    exit 0
fi

echo "Running Checkstyle on staged Java files using tools/sun_checks.xml..."

# List the files being checked
echo "Files to be checked:"
for file in $STAGED_FILES; do
    if [ -f "$file" ]; then
        echo "  - $file"
    fi
done

# Run checkstyle via Gradle using the configured task
# This will use the tools/sun_checks.xml configuration from build.gradle
echo "Executing Gradle checkstyle task..."
./gradlew :app:checkstyle --quiet || {
    echo ""
    echo " Checkstyle found code convention violations!"
    echo "Please fix the issues reported above and try again."
    echo "Configuration: tools/sun_checks.xml"
    exit 1
}

echo " Checkstyle passed for all staged Java files"
