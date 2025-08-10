#!/bin/bash

# pre-commit hook용 Checkstyle 실행기
# tools/sun_checks.xml과 함께 Gradle checkstyle 작업 사용

set -e

# 스테이징된 Java 파일 목록 가져오기
STAGED_FILES="$@"

if [ -z "$STAGED_FILES" ]; then
    echo "검사할 Java 파일이 없습니다"
    exit 0
fi

echo "tools/sun_checks.xml을 사용하여 스테이징된 Java 파일에 Checkstyle 실행 중..."

# 검사할 파일 목록 출력 및 Java 파일만 필터링
echo "검사할 파일들:"
JAVA_FILES=""
for file in $STAGED_FILES; do
    if [ -f "$file" ] && [[ "$file" == *.java ]]; then
        echo "  - $file"
        JAVA_FILES="$JAVA_FILES $file"
    fi
done

# 처리할 Java 파일이 있는지 확인
if [ -z "$JAVA_FILES" ]; then
    echo "스테이징된 파일 중 Java 파일을 찾을 수 없습니다"
    exit 0
fi

# 스테이징된 파일에만 checkstyle 실행
echo "스테이징된 파일에 Checkstyle 실행 중..."

# checkstyle을 특정 파일들에만 실행하기 위해 임시로 소스 경로 변경
# 기존 build.gradle의 checkstyle task를 수정하여 스테이징된 파일만 검사
./gradlew :app:checkstyle -Pcheckstyle.source.files="$JAVA_FILES" --quiet 2>/dev/null || {
    # 위 방법이 안되면 직접 checkstyle 실행
    echo "Gradle 속성을 통한 실행이 실패했습니다. 직접 checkstyle을 실행합니다..."
    
    # Java로 직접 checkstyle 실행
    CHECKSTYLE_JAR=$(find ~/.gradle/caches -name "checkstyle-*.jar" | head -1)
    if [ -z "$CHECKSTYLE_JAR" ]; then
        echo "Checkstyle JAR을 찾을 수 없습니다. Gradle을 통해 의존성을 다운로드합니다..."
        ./gradlew :app:dependencies --configuration checkstyle > /dev/null 2>&1
        CHECKSTYLE_JAR=$(find ~/.gradle/caches -name "checkstyle-*.jar" | head -1)
    fi
    
    if [ -n "$CHECKSTYLE_JAR" ]; then
        java -jar "$CHECKSTYLE_JAR" -c tools/sun_checks.xml $JAVA_FILES || {
            echo ""
            echo "❌ Checkstyle에서 코드 규칙 위반을 발견했습니다!"
            echo "위에서 보고된 문제를 수정한 후 다시 시도해주세요."
            echo "설정 파일: tools/sun_checks.xml"
            exit 1
        }
    else
        echo "❌ Checkstyle을 실행할 수 없습니다. JAR 파일을 찾을 수 없습니다."
        exit 1
    fi
}

echo "✅ 모든 스테이징된 Java 파일에 대해 Checkstyle 검사를 통과했습니다"
