# Search Filters

Comprehensive guide to Perplexity Search API filtering capabilities.

## Filter Types

### Domain Filtering

Restrict results to trusted domains:

```ts
const search = await client.search.create({
  query: "climate change research",
  searchDomainFilter: ["science.org", "pnas.org", "cell.com", "nature.com"],
  maxResults: 10,
});
```

**Best for:** Academic research, fact-checking, trusted source requirements.

### Recency Filtering

Filter by time period:

```ts
// Recent (past day)
const day = await client.search.create({
  query: "latest AI developments",
  searchRecencyFilter: "day",
});

// Past week
const week = await client.search.create({
  query: "latest AI developments",
  searchRecencyFilter: "week",
});

// Past month
const month = await client.search.create({
  query: "latest AI developments",
  searchRecencyFilter: "month",
});

// Past year
const year = await client.search.create({
  query: "latest AI developments",
  searchRecencyFilter: "year",
});
```

### Date Range Filtering

Specific date ranges:

```ts
const ranged = await client.search.create({
  query: "AI developments",
  searchAfterDateFilter: "01/01/2024",
  searchBeforeDateFilter: "12/31/2024",
  maxResults: 10,
});
```

### Academic Mode

Target scholarly sources:

```ts
const academic = await client.search.create({
  query: "machine learning algorithms",
  searchMode: "academic",
  maxResults: 10,
});
```

**Best for:** Research papers, citations, academic verification.

### Location-Based Search

Local search with geolocation:

```ts
const local = await client.search.create({
  query: "coffee shops",
  userLocationFilter: {
    latitude: 37.7749, // San Francisco
    longitude: -122.4194,
    radius: 10, // km
  },
  maxResults: 10,
});
```

## Multi-Query Search

Send multiple related queries in a single request (up to 5):

```ts
const search = await client.search.create({
  query: [
    "renewable energy trends 2024",
    "solar power innovations",
    "wind energy developments",
  ],
  maxResults: 10,
});
```

**Benefits:**

- More comprehensive results
- Reduced API request volume
- Diverse perspectives on complex topics

## Filter Combinations

Combine filters for precise results:

```ts
const research = await client.search.create({
  query: "quantum computing applications",
  searchDomainFilter: ["nature.com", "science.org"],
  searchMode: "academic",
  searchRecencyFilter: "year",
  maxResults: 5,
});
```

## Filter Selection Guide

| Goal                   | Recommended Filters                      |
| ---------------------- | ---------------------------------------- |
| Breaking news          | `searchRecencyFilter: 'day'`             |
| Recent developments    | `searchRecencyFilter: 'week'`            |
| Academic research      | `searchMode: 'academic'` + domain filter |
| Local information      | `userLocationFilter`                     |
| Fact-checking          | Domain filter for trusted sources        |
| Comprehensive overview | Multi-query search                       |
| Historical context     | Date range filters                       |
