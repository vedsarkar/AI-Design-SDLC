#!/bin/bash
# figma-comment.sh — post a single comment to a Figma file pinned to a node
# Usage:  figma-comment.sh FILE_KEY NODE_ID <<'EOF'
#         [Severity] Title
#
#         Body...
#         EOF
# Requires: $FIGMA_ACCESS_TOKEN in env

set -e

FILE_KEY="$1"
NODE_ID="$2"
MESSAGE="$(cat)"

if [ -z "$FIGMA_ACCESS_TOKEN" ]; then
  echo "Error: FIGMA_ACCESS_TOKEN not set" >&2
  exit 1
fi

PAYLOAD=$(MESSAGE="$MESSAGE" NODE_ID="$NODE_ID" python3 -c '
import json, os
print(json.dumps({
    "message": os.environ["MESSAGE"],
    "client_meta": {"node_id": os.environ["NODE_ID"], "node_offset": {"x": 0, "y": 0}}
}))
')

curl -s -X POST "https://api.figma.com/v1/files/${FILE_KEY}/comments" \
  -H "X-Figma-Token: ${FIGMA_ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  | python3 -m json.tool 2>/dev/null | grep -E '"id"|"error"' | head -2
