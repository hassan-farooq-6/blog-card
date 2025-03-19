#!/bin/bash

# Ensure the script is executed with a file argument
if [ -z "$1" ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

FILE="$1"

# Check if OpenAI API key is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ OPENAI_API_KEY is not set. Export it as an environment variable."
    exit 1
fi

# Read file content
CONTENT=$(cat "$FILE")

# Make an API call to OpenAI (GPT-4o Mini)
RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/chat/completions" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "gpt-4o-mini",
        "messages": [{"role": "system", "content": "You are an AI code reviewer."},
                     {"role": "user", "content": "'"$CONTENT"'"}]
    }')

# Extract review result
if echo "$RESPONSE" | grep -q "error"; then
    echo "❌ Error in AI review. Check API key or request format."
    exit 1
fi

echo "✅ AI Code Review Completed"
echo "$RESPONSE"
