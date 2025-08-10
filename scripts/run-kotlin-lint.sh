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

# Filter only Kotlin files
KOTLIN_FILES=""
for file in $STAGED_FILES; do
    if [ -f "$file" ] && [[ "$file" == *.kt || "$file" == *.kts ]]; then
        KOTLIN_FILES="$KOTLIN_FILES $file"
    fi
done

if [ -z "$KOTLIN_FILES" ]; then
    echo "No Kotlin files found in staged files"
    exit 0
fi

# List the files being checked
echo "Files to be checked:"
for file in $KOTLIN_FILES; do
    echo "  - $file"
done

# Check if ktlint binary is available, if not use gradle
if command -v ktlint >/dev/null 2>&1; then
    echo "Using ktlint binary..."
    
    # Run ktlint on specific files
    ktlint $KOTLIN_FILES || {
        echo ""
        echo "❌ Kotlin Lint found code style violations!"
        echo ""
        echo "To automatically fix some issues, you can run:"
        echo "  ktlint -F $KOTLIN_FILES"
        echo "  or"
        echo "  ./gradlew :app:ktlintFormat"
        echo ""
        echo "Please fix the Kotlin code style issues and try again."
        exit 1
    }
else
    echo "ktlint binary not found, using Gradle plugin..."
    echo "Note: This will check the entire project, not just staged files"
    
    # Fallback to gradle ktlint
    ./gradlew :app:ktlintCheck --quiet || {
        echo ""
        echo "❌ Kotlin Lint found code style violations!"
        echo ""
        echo "To automatically fix some issues, you can run:"
        echo "  ./gradlew :app:ktlintFormat"
        echo ""
        echo "Please fix the Kotlin code style issues and try again."
        exit 1
    }
fi

echo "✅ Kotlin Lint passed for all staged Kotlin files"
