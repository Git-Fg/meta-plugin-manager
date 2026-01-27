# SimpleWebFetch MCP Server

An MCP (Model Context Protocol) server that replicates the user-facing behavior of Anthropic's native WebFetch tool. This server provides six tools for optimal web content fetching, saving, crawling, and AI-powered analysis.

## Features

### Tools Implemented

1. **webFetch** ⭐ **RECOMMENDED - UNIFIED TOOL**
   - **OPTIMAL CHOICE** for all web fetching needs
   - Fetches a URL and returns clean markdown content
   - `includeMetadata=false` (default): Clean markdown for minimal context pollution (ideal for LLM context)
   - `includeMetadata=true`: Includes page title as markdown header when needed
   - Configurable options for timeout, user agent, caching, and content limits
   - **Use this tool instead of simpleWebFetch or fullWebFetch**

2. **simpleWebFetch** (Legacy - Use webFetch instead)
   - Legacy tool kept for backward compatibility
   - Equivalent to `webFetch` with `includeMetadata=false`
   - Use `webFetch` for new implementations

3. **fullWebFetch** (Legacy - Use webFetch instead)
   - Legacy tool kept for backward compatibility
   - Equivalent to `webFetch` with `includeMetadata=true`
   - Use `webFetch` for new implementations

4. **saveWebFetch**
   - Fetches a URL and saves the markdown content to a local file
   - Includes YAML frontmatter metadata (URL, title, fetch time)
   - Supports custom filenames or auto-generated from page title
   - Creates directory structure automatically

5. **crawlWebFetch**
   - Crawls multiple URLs matching a wildcard pattern
   - Saves all results to a specified directory
   - Leverages built-in multi-page crawling capabilities
   - Pattern matching with wildcard support (e.g., "https://example.com/*")

6. **askWebFetch** (AI-Powered Analysis)
   - Fetches a URL and uses OpenRouter AI to analyze the content based on a prompt
   - Requires OPENROUTER_API_KEY environment variable
   - Default behavior: extracts extensive key points from the content
   - Supports custom prompts for specific questions or analysis
   - Uses OpenRouter's free tier model (z-ai/glm-4.5-air:free) by default
   - Supports custom model selection

### Key Capabilities

- **URL Validation**: Rejects private/localhost URLs for security
- **Robots.txt Compliance**: Respects robots.txt by default
- **Content Truncation**: Prevents token overflow with configurable limits
- **Error Handling**: Clear, actionable error messages
- **File System Operations**: Save content to local filesystem with metadata
- **Pattern Matching**: Crawl multiple URLs using wildcard patterns
- **Type Safety**: Full TypeScript implementation with Zod validation

## Installation

```bash
npm install
npm run build
```

## Testing

### Basic Tests

```bash
# Test tools list
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' | node dist/server.js

# Test fullWebFetch
echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"fullWebFetch","arguments":{"url":"https://example.com"}}}' | node dist/server.js

# Test simpleWebFetch
echo '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"simpleWebFetch","arguments":{"url":"https://example.com"}}}' | node dist/server.js

# Test webFetch (default - clean markdown)
echo '{"jsonrpc":"2.0","id":3.1,"method":"tools/call","params":{"name":"webFetch","arguments":{"url":"https://example.com"}}}' | node dist/server.js

# Test webFetch (with metadata)
echo '{"jsonrpc":"2.0","id":3.2,"method":"tools/call","params":{"name":"webFetch","arguments":{"url":"https://example.com","includeMetadata":true}}}' | node dist/server.js

# Test saveWebFetch (auto-generated filename)
echo '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"saveWebFetch","arguments":{"url":"https://example.com","outputPath":"test/"}}}' | node dist/server.js

# Test saveWebFetch (custom filename)
echo '{"jsonrpc":"2.0","id":5,"method":"tools/call","params":{"name":"saveWebFetch","arguments":{"url":"https://example.com","outputPath":"test/custom.md"}}}' | node dist/server.js

# Test crawlWebFetch
echo '{"jsonrpc":"2.0","id":6,"method":"tools/call","params":{"name":"crawlWebFetch","arguments":{"pattern":"https://example.com/*","outputPath":"crawl/"}}}' | node dist/server.js

# Test askWebFetch (default - key points)
echo '{"jsonrpc":"2.0","id":7,"method":"tools/call","params":{"name":"askWebFetch","arguments":{"url":"https://example.com"}}}' | node dist/server.js

# Test askWebFetch (custom prompt)
echo '{"jsonrpc":"2.0","id":8,"method":"tools/call","params":{"name":"askWebFetch","arguments":{"url":"https://example.com","prompt":"What is this page about?"}}}' | node dist/server.js
```

### Using MCP Inspector

```bash
# List tools
npx -y @modelcontextprotocol/inspector --cli node dist/server.js --method tools/list

# Call fullWebFetch
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name fullWebFetch \
  --tool-arg url=https://example.com

# Call simpleWebFetch
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name simpleWebFetch \
  --tool-arg url=https://example.com

# Call webFetch (RECOMMENDED - default)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name webFetch \
  --tool-arg url=https://example.com

# Call webFetch (with metadata)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name webFetch \
  --tool-arg url=https://example.com \
  --tool-arg includeMetadata=true

# Call saveWebFetch (auto-generated filename)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name saveWebFetch \
  --tool-arg url=https://example.com \
  --tool-arg outputPath=test/

# Call saveWebFetch (custom filename)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name saveWebFetch \
  --tool-arg url=https://example.com \
  --tool-arg outputPath=test/custom-file.md

# Call crawlWebFetch
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name crawlWebFetch \
  --tool-arg pattern=https://example.com/* \
  --tool-arg outputPath=crawl/

# Call askWebFetch (default - key points)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name askWebFetch \
  --tool-arg url=https://example.com

# Call askWebFetch (custom prompt)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name askWebFetch \
  --tool-arg url=https://example.com \
  --tool-arg prompt="What are the main topics discussed on this page?"
```

## Usage

### Configuration for MCP Clients

Example MCP server configuration for Claude Desktop:

```json
{
  "mcpServers": {
    "simplewebfetch": {
      "command": "node",
      "args": ["/path/to/dist/server.js"],
      "env": {}
    }
  }
}
```

### Tool Parameters

#### fullWebFetch

**Required:**
- `url` (string): http(s) URL to fetch

**Optional:**
- `options.respectRobots` (boolean): Whether to respect robots.txt (default: true)
- `options.timeoutMs` (number): Request timeout in milliseconds (default: 30000, max: 60000)
- `options.userAgent` (string): Custom user agent string
- `options.cacheDir` (string): Directory for caching content
- `options.maxChars` (number): Maximum characters to return (default: 120000, max: 500000)

#### simpleWebFetch

**Purpose:** MANDATORY USE when needing to simply obtain the full context from a URL.

**Required:**
- `url` (string): http(s) URL to fetch

**Optional:** Same as fullWebFetch

**Behavior:**
- Fetches the complete page content
- Returns raw, unfiltered markdown without AI processing
- Use when you need the full context for analysis or further processing
- Returns: url, complete markdown content, and fetch timestamp

#### webFetch (RECOMMENDED)

**Purpose:** **OPTIMAL CHOICE** for all web fetching needs. This unified tool replaces simpleWebFetch and fullWebFetch.

**Required:**
- `url` (string): http(s) URL to fetch

**Optional:**
- `includeMetadata` (boolean): Include page title and metadata
  - `false` (default): Returns clean markdown only - **RECOMMENDED for LLM context**
  - `true`: Includes page title as markdown header
- `options` (object): Same crawl options as fullWebFetch

**Behavior:**
- **includeMetadata=false**: Fetches and returns clean markdown only
  - Minimal context pollution
  - Ideal for providing context to LLMs
  - Equivalent to simpleWebFetch
- **includeMetadata=true**: Fetches and returns markdown with title prefix
  - Includes page title when available
  - Equivalent to fullWebFetch

**Example Usage:**

```bash
# Clean markdown for LLM context (RECOMMENDED)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name webFetch \
  --tool-arg url=https://example.com/article

# With title when needed
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name webFetch \
  --tool-arg url=https://example.com/article \
  --tool-arg includeMetadata=true
```

**Returns:**
- Clean markdown in content field (minimal context pollution)
- Structured metadata: url, title (optional), markdown, fetchTime

#### saveWebFetch

**Required:**
- `url` (string): http(s) URL to fetch
- `outputPath` (string): Relative path or file path. Can be:
  - A directory path (e.g., 'docs/folder/') - will auto-generate filename from page title
  - A complete file path (e.g., 'docs/my-file.md') - will use the provided filename with any extension

**Optional:**
- `options` (object): Same crawl options as fullWebFetch

**Output:**
- Saves markdown file with YAML frontmatter metadata
- Returns file path, URL, title, file size, and fetch time

#### crawlWebFetch

**Required:**
- `pattern` (string): URL pattern with wildcard (e.g., 'https://example.com/*')
- `outputPath` (string): Relative path to save crawled files

**Optional:**
- `options.maxConcurrency` (number): Maximum concurrent requests (default: 3, max: 10)
- `options.respectRobots` (boolean): Whether to respect robots.txt (default: true)
- `options.timeoutMs` (number): Request timeout in milliseconds (default: 30000, max: 60000)
- `options.userAgent` (string): Custom user agent string
- `options.cacheDir` (string): Directory for caching content
- `options.maxChars` (number): Maximum characters per page (default: 120000, max: 500000)

**Output:**
- Saves multiple markdown files with YAML frontmatter
- Returns summary with total pages, success/failure counts, and file paths

#### askWebFetch (AI-Powered Analysis)

**Required:**
- `url` (string): http(s) URL to fetch and analyze

**Optional:**
- `prompt` (string): Custom prompt to ask about the content. If not provided, will default to extensive key points summary
- `model` (string): OpenRouter model to use (default: "z-ai/glm-4.5-air:free")
- `options` (object): Same crawl options as fullWebFetch

**Environment Variables Required:**
- `OPENROUTER_API_KEY`: Your OpenRouter API key (get one at https://openrouter.ai)

**Optional Environment Variables:**
- `SITE_URL`: Your site URL for OpenRouter rankings
- `SITE_NAME`: Your site name for OpenRouter rankings

**Configuration Example:**
```json
{
  "mcpServers": {
    "simplewebfetch": {
      "command": "node",
      "args": ["/path/to/dist/server.js"],
      "env": {
        "OPENROUTER_API_KEY": "sk-or-v1-...",
        "SITE_URL": "https://your-site.com",
        "SITE_NAME": "Your Site Name"
      }
    }
  }
}
```

**Behavior:**
- Fetches the URL content and sends it to OpenRouter AI for analysis
- If no prompt is provided, extracts extensive key points
- Returns AI-generated analysis as plain text
- Also returns structured content with URL, model, prompt, analysis, and timestamp

## Architecture

### Dependencies

- `@modelcontextprotocol/sdk`: Official MCP TypeScript SDK
- `@just-every/crawl`: Web crawling and markdown extraction
- `zod`: Schema validation

### Security Features

- Private IP/host validation (localhost, 127.0.0.1, RFC1918 ranges)
- Protocol validation (only http/https)
- Robots.txt compliance
- Configurable timeouts
- Content size limits
- Path validation for file operations (prevents directory traversal)
- Relative path enforcement for file saving

### File System Operations

The `saveWebFetch` and `crawlWebFetch` tools save content to the local filesystem:

1. **YAML Frontmatter**: Each saved file includes metadata:
   - Original URL
   - Page title
   - Fetch timestamp
   - Markdown content

2. **Filename Sanitization**: Automatic filename generation:
   - Converts titles to safe filenames
   - Replaces special characters with hyphens
   - Limits length to 100 characters
   - Adds .md extension

3. **Directory Management**:
   - Creates directories recursively
   - Enforces relative paths for security
   - Prevents absolute path traversal

## Evaluation

The server includes an evaluation file (`evaluation.xml`) with test cases covering:
- Basic fetching and extraction
- File saving operations
- Multi-URL crawling
- Pattern matching
- Error handling
- Custom options
- Content analysis
- API documentation extraction
- Path validation
- YAML frontmatter generation

## Usage Examples

### Example 1: Save a Single Page

```bash
# Save a documentation page to a local folder
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name saveWebFetch \
  --tool-arg url=https://docs.example.com/api-reference \
  --tool-arg outputPath=docs/api/
```

### Example 2: Custom Filename

```bash
# Save with a custom filename (auto-generates .md extension)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name saveWebFetch \
  --tool-arg url=https://blog.example.com/post \
  --tool-arg outputPath=blog/my-custom-post-name.md

# Or with a different extension
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name saveWebFetch \
  --tool-arg url=https://blog.example.com/post \
  --tool-arg outputPath=blog/notes.txt
```

### Example 3: Unified WebFetch Tool (RECOMMENDED)

```bash
# Fetch clean markdown for LLM context (RECOMMENDED)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name webFetch \
  --tool-arg url=https://docs.example.com/api-reference

# Fetch with title when needed
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name webFetch \
  --tool-arg url=https://blog.example.com/post \
  --tool-arg includeMetadata=true
```

### Example 4: Crawl Multiple Pages

```bash
# Crawl all blog posts from a site
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name crawlWebFetch \
  --tool-arg pattern=https://blog.example.com/posts/* \
  --tool-arg outputPath=crawled/posts/
```

### Example 5: High-Concurrency Crawling

```bash
# Crawl with increased concurrency for faster processing
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name crawlWebFetch \
  --tool-arg pattern=https://docs.example.com/* \
  --tool-arg outputPath=crawled/docs/ \
  --tool-arg options.maxConcurrency=5
```

### Example 6: AI-Powered Content Analysis (Default - Key Points)

```bash
# Analyze a URL and extract key points (default behavior)
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name askWebFetch \
  --tool-arg url=https://example.com/article
```

### Example 7: Custom Prompt Analysis

```bash
# Ask specific questions about the content
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name askWebFetch \
  --tool-arg url=https://docs.example.com/api \
  --tool-arg prompt="What are the authentication methods available in this API?"
```

### Example 8: Custom Model Selection

```bash
# Use a different OpenRouter model
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name askWebFetch \
  --tool-arg url=https://example.com/article \
  --tool-arg prompt="Summarize the main arguments in this article" \
  --tool-arg model="anthropic/claude-3-haiku"
```

### Example 9: Custom Options with AI Analysis

```bash
# Analyze with custom fetch options
npx -y @modelcontextprotocol/inspector --cli node dist/server.js \
  --method tools/call \
  --tool-name askWebFetch \
  --tool-arg url=https://example.com/long-article \
  --tool-arg prompt="Extract the actionable insights from this content" \
  --tool-arg options.maxChars=200000 \
  --tool-arg options.timeoutMs=45000
```

## Development

```bash
npm run dev    # Run in development mode with tsx
npm run build  # Compile TypeScript to JavaScript
npm test       # Run test suite
```

## License

MIT
