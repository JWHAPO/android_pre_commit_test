#!/bin/bash

# Kotlin Lint (ktlint) runner for pre-commit hook
# Uses Gradle ktlint plugin for staged Kotlin files

set -e

# Get the list of staged Kotlin files
STAGED_FILES="$@"

if [ -z "$STAGED_FILES" ]; then
    echo "No Kotlin files to lint"
    exit 0
fi

echo "Running Kotlin Lint on staged files using Gradle ktlint plugin..."

# List the files being checked
echo "Files to be checked:"
for file in $STAGED_FILES; do
    if [ -f "$file" ]; then
        echo "  - $file"
    fi
done

# Run ktlint via Gradle
echo "Executing Gradle ktlint tasks..."

# First run ktlintCheck to check for violations
./gradlew :app:ktlintCheck --quiet || {
    echo ""
    echo " Kotlin Lint found code style violations!"
    echo ""
    echo "To automatically fix some issues, you can run:"
    echo "  ./gradlew :app:ktlintFormat"
    echo ""
    echo "Please fix the Kotlin code style issues and try again."
    exit 1
}

echo " Kotlin Lint passed for all staged Kotlin files"
