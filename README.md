# Lodestar Claude Plugins

A Claude Code and Codex plugin marketplace for [Lodestar](https://github.com/ChainSafe/lodestar) and Ethereum consensus client development.

## Setup

### Claude Code

Install the marketplace in Claude Code:

```
/plugin marketplace add ChainSafe/lodestar-claude-plugins
```

Then install individual plugins:

```
/plugin install ethereum-rnd@lodestar-claude-plugins
/plugin install consensus-clients@lodestar-claude-plugins
/plugin install eth-rnd-archive@lodestar-claude-plugins
```

Auto-configure for a project by adding this to your project's `.claude/settings.json`:


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

### Codex

Install the marketplace in Codex:

```bash
codex plugin marketplace add ChainSafe/lodestar-claude-plugins
```

The `ethereum-rnd`, `consensus-clients`, and `eth-rnd-archive` plugins include Codex manifests and reuse the same skill definitions as Claude Code. The `zig-lsp` plugin is Claude Code only because it uses Claude-specific LSP metadata.

## Plugins

| Plugin | Description |
|--------|-------------|
| **ethereum-rnd** | Ethereum R&D reference lookup - consensus specs, beacon/execution APIs, EIPs, research forums, protocol governance |
| **consensus-clients** | Cross-reference CL client implementations - navigate codebases, compare architectures across 6 clients |
| **eth-rnd-archive** | Search the Ethereum R&D Discord Archive - find protocol discussions across 115+ channels |
| **zig-lsp** | Zig language server (ZLS) for code intelligence. Claude Code only. |

## Structure

- **`/plugins`** - Plugins developed and maintained by the Lodestar team
- **`/external_plugins`** - Third-party community plugins

## Contributing

### Adding a plugin

1. Create your plugin directory under `plugins/` (or `external_plugins/` for third-party)
2. Include a `.claude-plugin/plugin.json` manifest
3. Add your plugin entry to `.claude-plugin/marketplace.json`
4. Submit a pull request

### Plugin structure

Each plugin follows the standard Claude Code plugin structure. Portable plugins may also include `.codex-plugin/plugin.json` for Codex support.

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata (required)
├── .codex-plugin/
│   └── plugin.json      # Codex plugin metadata (optional)
├── .mcp.json            # MCP server configuration (optional)
├── commands/            # Slash commands (optional)
├── agents/              # Agent definitions (optional)
├── skills/              # Skill definitions (optional)
├── hooks/               # Event handlers (optional)
└── README.md            # Documentation
```

## License

See each plugin for its respective license.
