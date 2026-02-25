#!/usr/bin/env bash
# Eth R&D Archive — check for new messages in tracked channels
# Usage: bash check-updates.sh [specific-date]
# Outputs new messages as JSON to stdout

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$SCRIPT_DIR/config.json"
STATE="$SCRIPT_DIR/state.json"

# Read repo path from config, expand ~
REPO_PATH=$(python3 -c "import json, os; print(os.path.expanduser(json.load(open('$CONFIG')).get('repoPath', '~/ethereum-repos/eth-rnd-archive')))")
SPECIFIC_DATE="${1:-}"

# Initialize state file if missing
if [ ! -f "$STATE" ]; then
  echo '{"lastCommit": "", "lastCheck": ""}' > "$STATE"
fi

# Read tracked channels from config
CHANNELS=$(python3 -c "import json; print('\n'.join(json.load(open('$CONFIG'))['channels']))")

# Pull latest changes
cd "$REPO_PATH"
git pull --quiet 2>/dev/null || true

CURRENT_COMMIT=$(git rev-parse HEAD)
LAST_COMMIT=$(python3 -c "import json; print(json.load(open('$STATE')).get('lastCommit', ''))" 2>/dev/null || echo "")

if [ -n "$SPECIFIC_DATE" ]; then
    # Check a specific date across all tracked channels
    echo "{"
    echo "  \"mode\": \"specific-date\","
    echo "  \"date\": \"$SPECIFIC_DATE\","
    echo "  \"channels\": {"
    FIRST=true
    while IFS= read -r channel; do
        FILE="$REPO_PATH/$channel/$SPECIFIC_DATE.json"
        if [ -f "$FILE" ]; then
            if [ "$FIRST" = true ]; then FIRST=false; else echo ","; fi
            MSG_COUNT=$(python3 -c "import json; print(len(json.load(open('$FILE'))))")
            echo -n "    \"$channel\": {\"file\": \"$FILE\", \"messages\": $MSG_COUNT}"
        fi
    done <<< "$CHANNELS"
    echo ""
    echo "  },"
    echo "  \"commit\": \"$CURRENT_COMMIT\""
    echo "}"
elif [ -z "$LAST_COMMIT" ] || [ "$LAST_COMMIT" = "$CURRENT_COMMIT" ]; then
    echo "{"
    echo "  \"mode\": \"no-changes\","
    echo "  \"commit\": \"$CURRENT_COMMIT\""
    echo "}"
else
    # Diff mode — find changed files since last commit
    CHANGED_FILES=$(git diff --name-only "$LAST_COMMIT" "$CURRENT_COMMIT" 2>/dev/null || git diff --name-only HEAD~1 HEAD)

    echo "{"
    echo "  \"mode\": \"diff\","
    echo "  \"from\": \"$LAST_COMMIT\","
    echo "  \"to\": \"$CURRENT_COMMIT\","
    echo "  \"tracked_changes\": ["
    FIRST=true
    while IFS= read -r file; do
        CHANNEL=$(echo "$file" | cut -d'/' -f1)
        if echo "$CHANNELS" | grep -qx "$CHANNEL"; then
            if [[ "$file" == *.json ]] && [ -f "$REPO_PATH/$file" ]; then
                if [ "$FIRST" = true ]; then FIRST=false; else echo ","; fi
                MSG_COUNT=$(python3 -c "import json; print(len(json.load(open('$REPO_PATH/$file'))))" 2>/dev/null || echo "0")
                echo -n "    {\"channel\": \"$CHANNEL\", \"file\": \"$file\", \"messages\": $MSG_COUNT}"
            fi
        fi
    done <<< "$CHANGED_FILES"
    echo ""
    echo "  ]"
    echo "}"
fi

# Update state
python3 -c "
import json
from datetime import datetime, timezone
state = json.load(open('$STATE'))
state['lastCommit'] = '$CURRENT_COMMIT'
state['lastCheck'] = datetime.now(timezone.utc).isoformat()
json.dump(state, open('$STATE', 'w'), indent=2)
"
