#!/bin/sh

set -e

VERSION=$(./Scripts/get-version.sh)
ARTIFACT_BUNDLE=swifthooks-$VERSION.artifactbundle
ARTIFACT_BUNDLE_BIN=$ARTIFACT_BUNDLE/swifthooks/bin
BINARY_DIR=bin
OUTPUT_BINARY=$BINARY_DIR/swifthooks

mkdir -p $BINARY_DIR
mkdir -p $ARTIFACT_BUNDLE
mkdir -p $ARTIFACT_BUNDLE_BIN

# Copy files into bundle
cp LICENSE $ARTIFACT_BUNDLE
cp README.md $ARTIFACT_BUNDLE
cp CHANGELOG.md $ARTIFACT_BUNDLE

# Create bundle info.json from template, replacing version
INFO_TEMPLATE=Scripts/spm-artifact-bundle-info.template
sed 's/__VERSION__/'"${VERSION}"'/g' $INFO_TEMPLATE > "${ARTIFACT_BUNDLE}/info.json"

# Build multi-arch binary
swift build --disable-sandbox -c release --arch arm64
swift build --disable-sandbox -c release --arch x86_64
lipo -create -output $OUTPUT_BINARY .build/arm64-apple-macosx/release/swifthooks .build/x86_64-apple-macosx/release/swifthooks
strip -rSTX ${OUTPUT_BINARY}

# Copy macOS binary into bundle
cp $OUTPUT_BINARY $ARTIFACT_BUNDLE_BIN

# ZIP binary
FILENAME="swifthooks-v$VERSION.zip"
zip -r -j $FILENAME $OUTPUT_BINARY

# ZIP artifact bundle
ARTIFACT_BUNDLE_FILENAME="swifthooks-v$VERSION.artifactbundle.zip"
zip -r -X $ARTIFACT_BUNDLE_FILENAME $ARTIFACT_BUNDLE

# Clean-up
rm -rf $BINARY_DIR
rm -rf $ARTIFACT_BUNDLE

if [ -z "${GITHUB_ACTIONS}" ]; then
    echo "Binary created: $FILENAME"
    echo "SPM artifact bundle created: $ARTIFACT_BUNDLE_FILENAME"
else
    echo "FILENAME=${FILENAME}" >> $GITHUB_OUTPUT
    echo "ARTIFACT_BUNDLE_FILENAME=${ARTIFACT_BUNDLE_FILENAME}" >> $GITHUB_OUTPUT
fi