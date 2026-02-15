Anki MCP Server
===============

> **Note:** This is an npm-published fork of [scorzeth/anki-mcp-server](https://github.com/scorzeth/anki-mcp-server), packaged for easier installation and use.

An MCP server implementation that connects to a locally running Anki, providing card review and creation.

This server is designed to work with the [Anki desktop app](https://apps.ankiweb.net/) and the [Anki-Connect](https://foosoft.net/projects/anki-connect/) add-on.

Make sure you have the add-on installed before using.

Installation
------------

### From npm

```bash
npm install -g @mieubrisse/anki-mcp-server
```

### From source

```bash
git clone https://github.com/mieubrisse/anki-mcp-server.git
cd anki-mcp-server
npm install
npm run build
```

Resources
---------
- **anki://search/deckcurrent**
  - Returns all cards from current deck
  - Equivalent of `deck:current` in Anki
- **anki://search/isdue**
  - Returns cards in review and learning waiting to be studied
  - Equivalent of `is:due` in Anki
- **anki://search/isnew**
  - Returns all unseen cards 
  - Equivalent of `is:new` in Anki

Tools
-----
- **update_cards**
  - Marks cards with given card IDs as answered and gives them an ease score between 1 (Again) and 4 (Easy)
  - Inputs:
    - `answers` (array): Array of objects with `cardId` (number) and `ease` (number) fields

- **add_card**
  - Creates a new card in the Default Anki deck
  - Inputs:
    - `front` (string): Front of card
    - `back` (string): Back of card

- **get_due_cards**
  - Returns n number of cards currently due for review
  - Inputs:
    - `num` (number): Number of cards

- **get_new_cards**
  - Returns n number of cards from new
  - Inputs:
    - `num` (number): Number of cards

Development
-----------

### Using Docker and Make (recommended)

No local Node.js installation required. Just install Docker and Make:

```bash
# Build the project
make build

# Run publish dry-run (test without publishing)
make publish-dry-run

# Publish to npm (requires NPM_TOKEN)
NPM_TOKEN=your-npm-token make publish

# Clean build artifacts
make clean

# See all available commands
make help
```

### Using Node.js directly

Install dependencies:
```bash
npm install
```

Build the server:
```bash
npm run build
```

For development with auto-rebuild:
```bash
npm run watch
```

Configuration
-------------

### Using with Claude Desktop

After installing via npm, add the server config:

On MacOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
On Windows: `%APPDATA%/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "anki-mcp-server": {
      "command": "npx",
      "args": ["-y", "@mieubrisse/anki-mcp-server"]
    }
  }
}
```

Or if you built from source:

```json
{
  "mcpServers": {
    "anki-mcp-server": {
      "command": "/path/to/anki-mcp-server/build/index.js"
    }
  }
}
```

### Debugging

Since MCP servers communicate over stdio, debugging can be challenging. We recommend using the [MCP Inspector](https://github.com/modelcontextprotocol/inspector), which is available as a package script:

```bash
npm run inspector
```

The Inspector will provide a URL to access debugging tools in your browser.
