---
name: eth-rnd-archive
description: Search and track discussions from the Ethereum R&D Discord Archive. Use when looking for protocol discussions, researching what was said about a specific topic, tracking channel activity, or finding context for protocol decisions. Covers 115+ channels including consensus-dev, execution-dev, ePBS, PeerDAS, networking, and more.
---

# Eth R&D Archive Search & Tracker

Search and track discussions from the [Ethereum R&D Discord Archive](https://github.com/ethereum/eth-rnd-archive) — a machine-readable archive of all Eth R&D Discord channels, updated weekly by EF DevOps.

## Setup

```bash
# Clone the archive (613MB, one-time)
git clone https://github.com/ethereum/eth-rnd-archive.git ~/eth-rnd-archive
```

## Archive Structure

Each channel is a directory with daily JSON files:
```
channel-name/
├── 2026-02-20.json
├── 2026-02-21.json
├── _threads/
│   └── thread-name/
│       └── 2026-02-21.json
```

### Message Format

```json
{
  "author": "username",
  "category": "Discord category",
  "parent": "thread parent (empty if top-level)",
  "content": "message text",
  "created_at": "ISO8601 timestamp",
  "attachments": [...]
}
```

## Key Channels

### Core Protocol Development
| Channel | Topics |
|---------|--------|
| `consensus-dev` | CL protocol development, client team discussions |
| `execution-dev` | EL protocol development |
| `allcoredevs` | Cross-client coordination, ACD call follow-ups |
| `specifications` | Spec discussions, clarifications |
| `client-development` | General client engineering |
| `apis` | Beacon/Engine API design |

### Active Research Areas
| Channel | Topics |
|---------|--------|
| `epbs` | Enshrined proposer-builder separation design |
| `inclusion-lists` | FOCIL, inclusion list mechanisms |
| `data-availability-sampling` | DAS / PeerDAS protocol |
| `shorter-slot-times` | Slot time reduction research |
| `l1-zkevm` | CK EVM / L1 zkEVM |
| `l1-zkevm-protocol` | CK EVM protocol details (EIP-8025) |

### Networking & Testing
| Channel | Topics |
|---------|--------|
| `networking` | General networking protocol |
| `libp2p` | libp2p protocol discussions |
| `peerdas-testing` | PeerDAS test coordination |
| `peerdas-devnet-alerts` | PeerDAS devnet status/issues |

### Other Notable Channels
| Channel | Topics |
|---------|--------|
| `cryptography` | Cryptographic primitives, BLS, KZG |
| `formal-methods` | Formal verification |
| `post-quantum` | Post-quantum cryptography |
| `beacon-network` | Beacon chain networking |
| `portal-network` | Portal network protocol |
| `account-abstraction` | AA / ERC-4337 |
| `light-clients` | Light client protocol |
| `ai-workflows` | AI tooling for Ethereum development |

## How to Search

### Search a specific channel for a topic

```bash
# Search recent messages in a channel
cd ~/eth-rnd-archive
grep -rl "topic" consensus-dev/ | sort | tail -5

# Read messages from a specific date
cat consensus-dev/2026-02-21.json | python3 -c "
import json, sys
for msg in json.load(sys.stdin):
    if 'keyword' in msg['content'].lower():
        print(f\"[{msg['created_at']}] {msg['author']}: {msg['content'][:200]}\")
"
```

### Fetch via raw GitHub URLs (without cloning)

```
https://raw.githubusercontent.com/ethereum/eth-rnd-archive/master/{channel}/YYYY-MM-DD.json
```

Example — fetch yesterday's consensus-dev messages:
```bash
curl -s "https://raw.githubusercontent.com/ethereum/eth-rnd-archive/master/consensus-dev/$(date -u -d yesterday +%Y-%m-%d).json" | python3 -c "
import json, sys
msgs = json.load(sys.stdin)
print(f'{len(msgs)} messages')
for msg in msgs:
    print(f\"[{msg['author']}] {msg['content'][:150]}\")
"
```

### Search threads

Threads are stored in `_threads/` subdirectories:
```bash
# Find threads about a topic
find ~/eth-rnd-archive/epbs/_threads -name "*.json" | head -20

# Read a specific thread
cat "~/eth-rnd-archive/epbs/_threads/make it two clients/2026-02-23.json"
```

## Tracking Changes (Automated)

Use the included `check-updates.sh` script to track new messages:

```bash
# Check for new messages across tracked channels
bash scripts/check-updates.sh

# Check a specific date
bash scripts/check-updates.sh 2026-02-25
```

The script:
1. Pulls latest changes from the archive repo
2. Diffs against the last-checked commit (stored in `state.json`)
3. Outputs new/modified files from tracked channels as JSON
4. Updates the state file

### Configuration

Edit `scripts/config.json` to customize tracked channels:

```json
{
  "channels": ["epbs", "consensus-dev", "allcoredevs", ...],
  "checkIntervalMinutes": 60,
  "repoPath": "~/eth-rnd-archive"
}
```

## Tips

- **Start with the most relevant channel.** For broad protocol questions try `consensus-dev` or `execution-dev`. For specific features, use the dedicated channel.
- **Check threads.** Important discussions often happen in threads, not top-level messages.
- **Date-based access is fast.** If you know roughly when something was discussed, go straight to that date's file.
- **Archive updates weekly.** Don't expect real-time messages — there's typically a few days of lag.
- **Combine with ethereum-rnd plugin.** Use ethereum-rnd for spec/API reference, this plugin for discussion context.
