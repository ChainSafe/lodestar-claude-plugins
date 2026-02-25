#!/usr/bin/env bash
# Clone Ethereum R&D and consensus client repos for local search.
# Usage: bash clone-repos.sh [base-dir]
# Default base-dir: ~/ethereum-repos

set -euo pipefail

BASE="${1:-$HOME/ethereum-repos}"
mkdir -p "$BASE"

clone_or_pull() {
  local repo="$1"
  local dir="$BASE/$(basename "$repo")"
  if [ -d "$dir/.git" ]; then
    echo "Updating $repo..."
    git -C "$dir" pull --quiet 2>/dev/null || true
  else
    echo "Cloning $repo..."
    git clone --depth 1 "https://github.com/$repo.git" "$dir" 2>/dev/null
  fi
}

echo "=== Ethereum R&D Repos ==="
clone_or_pull "ethereum/consensus-specs"
clone_or_pull "ethereum/beacon-APIs"
clone_or_pull "ethereum/execution-apis"
clone_or_pull "ethereum/EIPs"
clone_or_pull "ethereum/builder-specs"
clone_or_pull "ethereum/devp2p"
clone_or_pull "ethereum/execution-specs"
clone_or_pull "ethereum/annotated-spec"
clone_or_pull "ethereum/pm"
clone_or_pull "ethereum/eth-rnd-archive"

echo ""
echo "=== Consensus Client Repos ==="
clone_or_pull "ChainSafe/lodestar"
clone_or_pull "sigp/lighthouse"
clone_or_pull "prysmaticlabs/prysm"
clone_or_pull "Consensys/teku"
clone_or_pull "status-im/nimbus-eth2"
clone_or_pull "grandinetech/grandine"

echo ""
echo "Done! Repos cloned to: $BASE"
echo "Total size: $(du -sh "$BASE" 2>/dev/null | cut -f1)"
