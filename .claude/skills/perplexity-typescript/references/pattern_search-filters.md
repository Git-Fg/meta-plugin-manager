# Search Filters

## Navigation

| If you need...        | Read...                           |
| :-------------------- | :-------------------------------- |
| Domain filtering      | ## PATTERN: Domain Filtering      |
| Recency filtering     | ## PATTERN: Recency Filtering     |
| Date range filtering  | ## PATTERN: Date Range Filtering  |
| Academic mode         | ## PATTERN: Academic Mode         |
| Location-based search | ## PATTERN: Location-Based Search |
| Multi-query search    | ## PATTERN: Multi-Query Search    |
| Filter combinations   | ## PATTERN: Filter Combinations   |

## Critical Read

<critical_read>
FIRST: Scan the navigation table above for your filter type.
KEY PATTERN: Search API filtering capabilities for precise result control.
COMMON MISTAKE: Using wrong date format—MM/DD/YYYY required for date filters.
REMEMBER: This reference contains the full source truth—read it, don't rely on summaries elsewhere.
</critical_read>

## PATTERN: Domain Filtering

Restrict results to trusted domains:

```ts
const search = await client.search.create({
  query: "climate change research",
  searchDomainFilter: ["science.org", "pnas.org", "cell.com", "nature.com"],
  maxResults: 10,
});
```

**Best for:** Academic research, fact-checking, trusted source requirements.

## PATTERN: Recency Filtering

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

## PATTERN: Date Range Filtering

Specific date ranges:

```ts
const ranged = await client.search.create({
  query: "AI developments",
  searchAfterDateFilter: "01/01/2024",
  searchBeforeDateFilter: "12/31/2024",
  maxResults: 10,
});
```

## PATTERN: Academic Mode

Target scholarly sources:

```ts
const academic = await client.search.create({
  query: "machine learning algorithms",
  searchMode: "academic",
  maxResults: 10,
});
```

**Best for:** Research papers, citations, academic verification.

## PATTERN: Location-Based Search

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

## PATTERN: Multi-Query Search

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

## PATTERN: Filter Combinations

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

---

## Absolute Constraints

<critical_constraint>
MANDATORY: Use MM/DD/YYYY format for date filters—other formats will fail.
MANDATORY: Limit to 5 queries in multi-query search—additional queries will be ignored.
FORBIDDEN: Summary sections—create spoilers that let agents skip reading the actual content.
</critical_constraint>
