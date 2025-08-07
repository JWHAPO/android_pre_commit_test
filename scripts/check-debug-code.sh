#!/bin/bash

# Debug code detection for pre-commit hook
# Checks for debugging statements in staged Java/Kotlin files

set -e

# Get the list of staged files
STAGED_FILES="$@"

if [ -z "$STAGED_FILES" ]; then
    echo "No Java/Kotlin files to check for debug code"
    exit 0
fi

echo "Checking for debug code in staged files..."

# Define debug patterns to search for
DEBUG_PATTERNS=(
    "Log\.[dviwe]"          # Android Log.d, Log.v, Log.i, Log.w, Log.e
    "System\.out\.print"    # System.out.print/println
    "System\.err\.print"    # System.err.print/println
    "printStackTrace"       # Exception printStackTrace
    "Trace\."              # Android Trace methods
    "Debug\."              # Android Debug methods
    "console\.log"         # JavaScript-style console.log (sometimes used in hybrid apps)
    "println\("            # Kotlin println
    "print\("              # Kotlin print
)

FOUND_DEBUG_CODE=false
DEBUG_FILES=()

# Check each staged file for debug patterns
for file in $STAGED_FILES; do
    if [ -f "$file" ]; then
        echo "Checking: $file"
        
        for pattern in "${DEBUG_PATTERNS[@]}"; do
            if grep -n "$pattern" "$file" 2>/dev/null; then
                echo "❌ Debug code found in $file:"
                grep -n --color=always "$pattern" "$file" 2>/dev/null || true
                FOUND_DEBUG_CODE=true
                DEBUG_FILES+=("$file")
                break
            fi
        done
    fi
done

if [ "$FOUND_DEBUG_CODE" = true ]; then
    echo ""
    echo "❌ Debug code detected in the following files:"
    printf '%s\n' "${DEBUG_FILES[@]}"
    echo ""
    echo "Please remove debug statements before committing:"
    echo "- Log.d/v/i/w/e statements"
    echo "- System.out.print/println"
    echo "- printStackTrace calls"
    echo "- Trace.* methods"
    echo "- println() / print() statements"
    echo ""
    exit 1
fi

echo "✅ No debug code found in staged files"
