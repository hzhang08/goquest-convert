#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <kifu_id>"
    exit 1
fi

KIFU_ID=$1
API_URL="https://kifu.questgames.net/game/${KIFU_ID}.json"

# Fetch the data
echo "Fetching from: $API_URL"
RESPONSE=$(curl -s "$API_URL")

if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch data"
    exit 1
fi

# Extract size and create SGF header
SIZE=$(echo "$RESPONSE" | jq -r '.position.size')
SGF="(;FF[4]GM[1]SZ[${SIZE}]"

# Extract and append moves
MOVES=$(echo "$RESPONSE" | jq -r '.position.moves[].m' | tr '\n' ';')
SGF="${SGF}${MOVES})"

echo "Raw Response:"
echo "$RESPONSE" | jq '.'
echo
echo "Converted SGF:"
echo "$SGF"
