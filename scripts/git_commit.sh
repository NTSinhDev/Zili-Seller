#!/bin/bash
# Script để stage và commit changes
# Usage: git_commit.sh "commit message"

if [ -z "$1" ]; then
    echo "❌ Vui lòng nhập commit message!"
    echo "Usage: git_commit.sh \"commit message\""
    exit 1
fi

echo "Staging all changes..."
git add -A
if [ $? -ne 0 ]; then
    echo "❌ git add failed!"
    exit 1
fi

echo ""
echo "Committing with message: $1"
git commit -m "$1"
if [ $? -ne 0 ]; then
    echo "❌ git commit failed!"
    exit 1
fi

echo ""
echo "✅ Commit thành công!"

