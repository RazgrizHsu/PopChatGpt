#!/bin/bash

SCHEME="PopChatGpt"
CONFIGURATION="Release"
PROJECT_NAME="$SCHEME.xcodeproj"
BUILD_DIR="build"
DESTINATION="generic/platform=macos"

rm -rf build/*.zip

# increase（CFBundleVersion）
agvtool next-version -all
if [ $? -eq 0 ]; then
    echo "Build number incremented successfully."
else
    echo "Failed to increment build number."
    exit 1
fi

NEW_VERSION=""
DEST_PATH=""
UPDATE_VER=false

# check arg is 1.0.0 | -ver | /path/to/app
for ARG in "$@"; do
    if [[ $ARG =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        NEW_VERSION=$ARG
    elif [[ $ARG =~ ^/.* ]]; then
        DEST_PATH=$ARG
        if [[ $DEST_PATH == /app/* ]]; then
            DEST_PATH="/Applications/${DEST_PATH:5}"
        fi
    elif [[ $ARG == "--ver" ]]; then
        UPDATE_VER=true
    fi
done

if [ "$UPDATE_VER" = true ]; then
    # increase（CFBundleShortVersionString）
    CURRENT_VERSION=$(agvtool what-marketing-version -terse1)
    if [ -z "$CURRENT_VERSION" ]; then
        echo "Failed to get current marketing version."
        exit 1
    fi
    IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
    if [ ${#VERSION_PARTS[@]} -ne 3 ]; then
        echo "Current marketing version format is incorrect: $CURRENT_VERSION"
        exit 1
    fi
    LAST_INDEX=$((${#VERSION_PARTS[@]}-1))
    VERSION_PARTS[$LAST_INDEX]=$((${VERSION_PARTS[$LAST_INDEX]}+1))
    NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.${VERSION_PARTS[2]}"
    agvtool new-marketing-version $NEW_VERSION
    if [ $? -eq 0 ]; then
        echo "Updated marketing version to $NEW_VERSION."
    else
        echo "Failed to update marketing version."
        exit 1
    fi
elif [ -n "$NEW_VERSION" ]; then
    agvtool new-marketing-version $NEW_VERSION
    if [ $? -eq 0 ]; then
        echo "Updated marketing version to $NEW_VERSION."
    else
        echo "Failed to update marketing version."
        exit 1
    fi
fi

# xcodebuild clean -project "$PROJECT_NAME" -scheme "$SCHEME" -configuration "$CONFIGURATION"
xcodebuild -project "$PROJECT_NAME" -scheme "$SCHEME" -configuration "$CONFIGURATION" -destination "$DESTINATION" -derivedDataPath "$BUILD_DIR"

APP_PATH=$(find "$BUILD_DIR" -name "$SCHEME.app" -print -quit)

if [ -z "$APP_PATH" ]; then
    echo "not found .app"
    exit 1
else
    echo "build success, app path: $APP_PATH"
fi

VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$APP_PATH/Contents/Info.plist")

if [ -z "$VERSION" ]; then
    echo "not found version number"
    exit 1
else
    echo "version number: $VERSION"
fi

# copy app
if [ -n "$DEST_PATH" ]; then
    if [ -d "$DEST_PATH" ]; then
        rm -rf "$DEST_PATH/$SCHEME.app"
    fi
    cp -R "$APP_PATH" "$DEST_PATH"
    if [ $? -eq 0 ]; then
        echo "App copied to $DEST_PATH successfully."
    else
        echo "Failed to copy app to $DEST_PATH."
        exit 1
    fi
fi

TEMP_DIR=$(mktemp -d)
cp -R "$APP_PATH" "$TEMP_DIR"

echo "tmpdir: $TEMP_DIR"

ZIP_FILE="${SCHEME}.${VERSION}.zip"
cd "$TEMP_DIR"
7z a -tzip -mx9 "$ZIP_FILE" "$SCHEME.app"

if [ $? -eq 0 ]; then
    mv "$ZIP_FILE" "$OLDPWD"
    echo "compression success, zip file: $OLDPWD/$ZIP_FILE"
else
    echo "compression failed"
    cd -
    rm -rf "$TEMP_DIR"
    exit 1
fi

cd -
rm -rf "$TEMP_DIR"
