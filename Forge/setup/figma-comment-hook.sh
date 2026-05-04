#!/bin/bash
# PreToolUse hook for Bash — intercepts the `# figma_comment` trigger and posts
# to Figma. All comment data is read from /tmp/.claude-figma-comment so the
# bash command itself stays a single short line.
#
# Format of /tmp/.claude-figma-comment:
#   Line 1: FILE_KEY
#   Line 2: NODE_ID
#   Line 3: (blank)
#   Line 4+: message (title + blank line + body)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))")

# Only act on the exact trigger line (allow trailing whitespace/newlines)
TRIMMED=$(echo "$COMMAND" | head -1 | sed 's/[[:space:]]*$//')
if [ "$TRIMMED" != "# figma_comment" ]; then
  echo '{}'
  exit 0
fi

DATA_FILE="/tmp/.claude-figma-comment"
if [ ! -f "$DATA_FILE" ]; then
  echo '{"continue": false, "stopReason": "No comment data: write FILE_KEY, NODE_ID, blank line, then message to /tmp/.claude-figma-comment first."}'
  exit 0
fi

FILE_KEY=$(sed -n '1p' "$DATA_FILE" | tr -d '[:space:]')
NODE_ID=$(sed -n '2p' "$DATA_FILE" | tr -d '[:space:]')
MESSAGE=$(tail -n +4 "$DATA_FILE")

if [ -z "$FILE_KEY" ] || [ -z "$NODE_ID" ] || [ -z "$MESSAGE" ]; then
  echo '{"continue": false, "stopReason": "Comment data is malformed. Expected: line 1 FILE_KEY, line 2 NODE_ID, line 3 blank, line 4+ message."}'
  exit 0
fi

RESPONSE=$(echo "$MESSAGE" | ~/.claude/scripts/figma-comment.sh "$FILE_KEY" "$NODE_ID" 2>&1)
rm -f "$DATA_FILE"

SAFE_RESPONSE=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.dumps(sys.stdin.read().strip()))")
echo "{\"continue\": false, \"systemMessage\": \"Figma comment posted → $NODE_ID — $SAFE_RESPONSE\"}"
