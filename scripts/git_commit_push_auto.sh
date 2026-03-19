#!/bin/bash
# Script để tự động generate commit message, commit và push
# Usage: git_commit_push_auto.sh

echo "Generating commit message from changes..."
OUTPUT=$(dart run scripts/generate_commit_message.dart)

if [ $? -ne 0 ]; then
    echo "❌ Không thể generate commit message!"
    exit 1
fi

# Parse output để lấy title và body
COMMIT_TITLE=""
COMMIT_BODY=""

while IFS= read -r line; do
    if [[ $line == TITLE:* ]]; then
        COMMIT_TITLE="${line#TITLE:}"
    elif [[ $line == BODY:* ]]; then
        COMMIT_BODY="${line#BODY:}"
    fi
done <<< "$OUTPUT"

if [ -z "$COMMIT_TITLE" ]; then
    echo "❌ Không thể tạo commit title!"
    exit 1
fi

echo ""
echo "Generated commit title: $COMMIT_TITLE"
if [ -n "$COMMIT_BODY" ]; then
    echo "Generated commit body:"
    echo "$COMMIT_BODY"
fi
echo ""

echo "Staging all changes..."
git add -A
if [ $? -ne 0 ]; then
    echo "❌ git add failed!"
    exit 1
fi

echo ""
echo "Committing with auto-generated message..."
if [ -z "$COMMIT_BODY" ]; then
    # Chỉ có title
    git commit -m "$COMMIT_TITLE"
else
    # Có cả title và body
    git commit -m "$COMMIT_TITLE" -m "$COMMIT_BODY"
fi

if [ $? -ne 0 ]; then
    echo "❌ git commit failed!"
    exit 1
fi

echo ""
echo "Pushing to remote..."
git push
if [ $? -ne 0 ]; then
    echo "❌ git push failed!"
    exit 1
fi

echo ""
echo "✅ Commit và push thành công!"
echo "Title: $COMMIT_TITLE"

