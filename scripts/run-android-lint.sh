#!/bin/bash

# Runs Android Lint on the entire app module

# 실제로 스테이징된 파일만 린팅하려면: Android Lint는 기본적으로 특정 파일만 대상으로 하는 기능이 제한적입니다. 대안으로는:

# 파일별 개별 실행 (매우 느림)
# 커스텀 lint 설정 파일 생성
# 다른 도구 사용 (예: ktlint는 개별 파일 지원)

set -e

echo "Running Android Lint on app module..."

# Run Android lint on the entire app
./gradlew :app:lintDebug --quiet || {
    echo "Android Lint found issues"
    exit 1
}

echo "Android Lint passed"
