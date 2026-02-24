# Lodestar Claude Plugins

A Claude Code plugin marketplace for [Lodestar](https://github.com/ChainSafe/lodestar) and Ethereum consensus client development.

## Installation

Add this marketplace to Claude Code:

```
/plugin marketplace add <owner>/<repo>
```

Then install individual plugins:

```
/plugin install <plugin-name>@lodestar-claude-plugins
```

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
