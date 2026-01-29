# Data Extraction

Scraping, screenshots, and content extraction.

## Screenshot

```bash
agent-browser open "https://example.com/page"
agent-browser screenshot page.png
```

## Extract Element Data

```bash
agent-browser open "https://example.com/data"
agent-browser snapshot

# Get text content
agent-browser get text @e10

# Get attribute value
agent-browser get attr @e10 href

# Get all links
agent-browser snapshot -c | grep "href:"
```

## Table Extraction

```bash
agent-browser open "https://example.com/table"
agent-browser snapshot -s "table" > table.txt

# Extract row data
grep -A 1 "tr" table.txt | while read line; do
  echo "$line"
done
```

## Scroll and Load

```bash
agent-browser open "https://example.com/infinite-scroll"

for i in {1..5}; do
  agent-browser scroll down 1000
  sleep 1
  agent-browser snapshot -i
done

agent-browser get text @items_container
```
