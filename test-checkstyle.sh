#!/bin/bash

# Test script to verify Gradle checkstyle setup

echo "🧪 Testing Gradle checkstyle configuration..."

# Check if tools/sun_checks.xml exists
if [ ! -f "tools/sun_checks.xml" ]; then
    echo "❌ tools/sun_checks.xml not found!"
    exit 1
fi

echo "✅ tools/sun_checks.xml found"

# List available gradle tasks related to checkstyle
echo ""
echo "📋 Available Gradle tasks containing 'checkstyle':"
./gradlew tasks --all | grep -i checkstyle || echo "No checkstyle tasks found"

echo ""
echo "🔍 Testing checkstyle task execution..."

# Try to run the checkstyle task
./gradlew :app:checkstyle || {
    echo ""
    echo "❌ Checkstyle task failed or not found"
    echo "Let's try alternative task names..."
    
    # Try other common checkstyle task names
    ./gradlew :app:checkstyleMain || {
        ./gradlew checkstyle || {
            echo "❌ No working checkstyle task found"
            exit 1
        }
    }
}

echo ""
echo "✅ Checkstyle task executed successfully!"
echo "✅ Your setup is working with tools/sun_checks.xml"
