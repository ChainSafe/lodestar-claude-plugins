# Lodestar Claude Plugins

A Claude Code plugin marketplace for [Lodestar](https://github.com/ChainSafe/lodestar) and Ethereum consensus client development.

## Setup

### 1. Clone reference repos locally (recommended)

For best performance, clone Ethereum spec repos and client codebases locally:

```bash
bash scripts/clone-repos.sh  # clones to ~/ethereum-repos by default
```

This enables fast `grep`/`find`/`cat` access instead of slow WebFetch calls. The plugins will fall back to WebFetch if repos aren't cloned.

### 2. Install the marketplace in Claude Code

```
/plugin marketplace add ChainSafe/lodestar-claude-plugins
```

Then install individual plugins:

```
/plugin install ethereum-rnd@lodestar-claude-plugins
/plugin install consensus-clients@lodestar-claude-plugins
/plugin install eth-rnd-archive@lodestar-claude-plugins
```

### 3. Auto-configure for a project

Add to your project's `.claude/settings.json` to auto-prompt team members:

```json
{
  "enabledPlugins": {
    "ethereum-rnd@lodestar-claude-plugins": true,
    "consensus-clients@lodestar-claude-plugins": true,
    "eth-rnd-archive@lodestar-claude-plugins": true
  },
  "extraKnownMarketplaces": {
    "lodestar-claude-plugins": {
      "source": {
        "source": "github",
        "repo": "ChainSafe/lodestar-claude-plugins"
      }
    }
  }
}
```

## Plugins

| Plugin | Description |
|--------|-------------|
| **ethereum-rnd** | Ethereum R&D reference lookup — consensus specs, beacon/execution APIs, EIPs, research forums, protocol governance |
| **consensus-clients** | Cross-reference CL client implementations — navigate codebases, compare architectures across 6 clients |
| **eth-rnd-archive** | Search the Ethereum R&D Discord Archive — find protocol discussions across 115+ channels |
| **zig-lsp** | Zig language server (ZLS) for code intelligence |

## Structure

- **`/plugins`** - Plugins developed and maintained by the Lodestar team
- **`/scripts`** - Shared setup scripts (repo cloning, updates)
- **`/external_plugins`** - Third-party community plugins

## Contributing

### Adding a plugin

1. Create your plugin directory under `plugins/` (or `external_plugins/` for third-party)
2. Include a `.claude-plugin/plugin.json` manifest
3. Add your plugin entry to `.claude-plugin/marketplace.json`
4. Submit a pull request

### Plugin structure

Each plugin follows the standard Claude Code plugin structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata (required)
├── .mcp.json            # MCP server configuration (optional)
├── commands/            # Slash commands (optional)
├── agents/              # Agent definitions (optional)
├── skills/              # Skill definitions (optional)
├── hooks/               # Event handlers (optional)
└── README.md            # Documentation
```

## License

See each plugin for its respective license.
