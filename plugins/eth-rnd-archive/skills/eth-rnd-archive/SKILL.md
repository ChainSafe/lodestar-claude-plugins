---
name: eth-rnd-archive
description: Search the Ethereum R&D Discord Archive for protocol discussions. Use when looking up what was discussed about a specific topic (ePBS, PeerDAS, inclusion lists, etc.), finding decisions made in Eth R&D Discord, or tracking research conversations. Requires a local clone of ethereum/eth-rnd-archive.
---

# Eth R&D Discord Archive Search

Search through the [Ethereum R&D Discord Archive](https://github.com/ethereum/eth-rnd-archive) — a machine-readable archive of all discussions in the Eth R&D Discord server. Updated weekly by EF DevOps.

## Setup

Clone the archive repo locally (included in `scripts/clone-repos.sh`):

```bash
git clone --depth 1 https://github.com/ethereum/eth-rnd-archive.git ~/ethereum-repos/eth-rnd-archive
```

## Searching the Archive

The archive contains daily JSON files per channel: `{channel}/YYYY-MM-DD.json`

### Search by topic across all channels

```bash
# Find discussions about a topic
grep -rl "PeerDAS" ~/ethereum-repos/eth-rnd-archive/ --include="*.json" | head -20

# Search with context (shows the actual message content)
grep -r "inclusion list" ~/ethereum-repos/eth-rnd-archive/consensus-dev/ --include="*.json" -l

# Read messages from a specific channel and date
cat ~/ethereum-repos/eth-rnd-archive/epbs/2026-02-20.json | python3 -m json.tool
```

### Search a specific channel

```bash
# Recent messages in a channel
ls -t ~/ethereum-repos/eth-rnd-archive/consensus-dev/*.json | head -5 | xargs cat | python3 -c "
import json, sys
for line in sys.stdin:
    try:
        msgs = json.loads(line)
        for m in msgs:
            print(f\"[{m['created_at'][:10]}] {m['author']}: {m['content'][:200]}\")
    except: pass
"
```

### Search threads

Threads are stored in `_threads/` subdirectories:

```bash
# List all threads in a channel
ls ~/ethereum-repos/eth-rnd-archive/epbs/_threads/

# Search within threads
grep -r "keyword" ~/ethereum-repos/eth-rnd-archive/epbs/_threads/ --include="*.json"
```

## Key Channels

### Core Protocol Development
| Channel | Topics |
|---------|--------|
| `consensus-dev` | CL protocol development, client coordination |
| `execution-dev` | EL protocol development |
| `allcoredevs` | Cross-layer coordination, ACD call follow-ups |
| `specifications` | Formal spec discussions |
| `apis` | Beacon/Engine API design |
| `client-development` | Client team discussions |

### Active Research Areas
| Channel | Topics |
|---------|--------|
| `epbs` | Enshrined proposer-builder separation |
| `inclusion-lists` | Inclusion list design (FOCIL, etc.) |
| `shorter-slot-times` | Slot time reduction research |
| `data-availability-sampling` | DAS / PeerDAS design |
| `l1-zkevm` | CK EVM / L1 zkEVM |
| `l1-zkevm-protocol` | CK EVM protocol details |

### Networking & Testing
| Channel | Topics |
|---------|--------|
| `networking` | General networking protocol discussions |
| `libp2p` | libp2p protocol development |
| `peerdas-testing` | PeerDAS test coordination |
| `peerdas-devnet-alerts` | PeerDAS devnet status/alerts |

### Other Notable Channels
| Channel | Topics |
|---------|--------|
| `cryptography` | Crypto primitives, hash functions |
| `formal-methods` | Formal verification |
| `post-quantum` | Post-quantum cryptography |
| `beacon-network` | Beacon chain networking |
| `portal-network` | Portal network protocol |
| `account-abstraction` | AA design |
| `light-clients` | Light client protocol |

## Message Format

Each JSON file contains an array of messages:

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

## Tracking Updates

Use the provided script to check for new messages in configured channels:

```bash
bash scripts/check-updates.sh [specific-date]
```

The script:
1. Pulls latest changes from the archive repo
2. Compares against the last-checked commit (stored in `scripts/state.json`)
3. Outputs new/modified files from tracked channels as JSON

### Configuration

Edit `scripts/config.json` to configure which channels to track:

```json
{
  "channels": ["epbs", "consensus-dev", "allcoredevs", ...],
  "repoPath": "~/ethereum-repos/eth-rnd-archive"
}
```

## Tips

- **Start with the right channel.** Use the channel table above to narrow your search before grepping the whole archive.
- **Date-based browsing** is useful for finding what was discussed around specific events (ACD calls, devnet launches).
- **Thread names** often describe the topic — `ls _threads/` gives a quick overview of discussion threads.
- **Authors matter** — filter by known contributors (e.g., `grep -r '"author": "vbuterin"'`) for high-signal content.
- **Keep the clone updated** — `git -C ~/ethereum-repos/eth-rnd-archive pull` before searching for recent discussions.
