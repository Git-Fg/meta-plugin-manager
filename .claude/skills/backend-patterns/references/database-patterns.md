# Database Patterns Reference

Database optimization, query patterns, and data persistence best practices.

---

## Query Optimization

### Select Only Needed Columns

**WHY**: Reduces bandwidth, speeds up queries, lowers memory usage.

```typescript
// GOOD: Select specific columns
const { data } = await supabase
  .from('markets')
  .select('id, name, status, volume')
  .eq('status', 'active')

// BAD: Select everything
const { data } = await supabase
  .from('markets')
  .select('*')  // Returns all columns, including large JSON fields
```

### Use Indexes

**WHY**: Indexes speed up queries dramatically.

```typescript
// Create index on frequently queried columns
await db.$executeRaw`
  CREATE INDEX idx_markets_status ON markets(status)
  CREATE INDEX idx_markets_created_at ON markets(created_at DESC)
  CREATE INDEX idx_markets_status_volume ON markets(status, volume DESC)
`
```

**When to index**:
- Columns used in WHERE clauses
- Columns used in JOIN conditions
- Columns used in ORDER BY
- Columns frequently queried

### Query Ordering

```typescript
// GOOD: Order by indexed column
await db.markets.findMany({
  orderBy: { createdAt: 'desc' }  // Uses index
})

// AVOID: Order by computed expression
await db.markets.findMany({
  orderBy: { volume: 'desc' }  // May not use index
})

// BETTER: Add computed column with index
// ALTER TABLE markets ADD volume_rank INTEGER
// CREATE INDEX idx_markets_volume_rank ON markets(volume_rank)
```

---

## N+1 Query Prevention

### Batch Fetching Pattern

**Problem**: N queries inside loop
```typescript
// BAD: N+1 query problem
const markets = await getMarkets()
for (const market of markets) {
  market.positions = await getPositions(market.id)  // N queries!
}
```

**Solution**: Fetch all related data in one query
```typescript
// GOOD: Batch fetch
const markets = await getMarkets()
const marketIds = markets.map(m => m.id)

// Single query for all positions
const allPositions = await db.positions.findMany({
  where: { marketId: { in: marketIds } }
})

// Map back to markets
const positionsByMarket = groupBy(allPositions, 'marketId')
markets.forEach(market => {
  market.positions = positionsByMarket[market.id] || []
})
```

### Include/Join Pattern

```typescript
// GOOD: Use include for related data
const marketsWithPositions = await db.markets.findMany({
  include: {
    positions: {
      select: { id: true, title: true }
    }
  }
})
```

---

## Transaction Patterns

### Simple Transaction

```typescript
await db.$transaction(async (tx) => {
  const market = await tx.market.create({
    data: { name: 'Test Market' }
  })

  await tx.position.create({
    data: {
      marketId: market.id,
      title: 'Yes Position'
    }
  })
})
```

### Isolation Levels

```typescript
await db.$transaction(
  async (tx) => {
    // Transaction logic
  },
  {
    maxWait: 5000,      // Maximum time to wait for transaction
    timeout: 10000,    // Maximum time transaction can run
    isolationLevel: 'ReadCommitted'
  }
)
```

---

## Connection Pooling

### Prisma Connection Pool

```typescript
// prisma/schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
  pool_timeout = 60
  connection_limit = 10
}
```

### Connection Pool Best Practices

- Set `connection_limit` based on your DB size
- Use connection pooling in serverless environments
- Close connections when done (or use pool)
- Monitor pool usage

---

## Database Migration Patterns

### Versioned Migrations

```typescript
// prisma/migrations/20240101_create_markets/migration.sql
CREATE TABLE markets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(200) NOT NULL,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_markets_status ON markets(status);
```

### Rollback Pattern

```typescript
// Down migration
export async function down(prisma: PrismaClient) {
  await prisma.$executeRaw`DROP INDEX idx_markets_status`
  await prisma.$executeRaw`DROP TABLE markets`
}
```

---

## Data Integrity

### Constraints

```typescript
model Market {
  id        String   @id @default(uuid())
  name      String   @unique
  status    String   @default("active")
  createdAt DateTime @default(now())

  @@index([status])
  @@map("markets")
}
```

### Foreign Key Relationships

```typescript
model Position {
  id       String  @id @default(uuid())
  market   Market  @relation(fields: [marketId], references: [id])
  marketId String
  title    String

  @@index([marketId])
}

model Market {
  id        String     @id @default(uuid())
  positions Position[]
}
```

---

## Backup Patterns

### Automated Backups

```typescript
// Backup script (run daily)
export async function backupDatabase() {
  const timestamp = new Date().toISOString().split('T')[0]
  const filename = `backup_${timestamp}.sql`

  await exec(`pg_dump ${process.env.DATABASE_URL} > backups/${filename}`)
  console.log(`Backup created: ${filename}`)
}
```

### Point-in-Time Recovery

- Configure WAL (Write-Ahead Logging)
- Set retention period for WAL files
- Test restore procedure regularly

---

## Performance Monitoring

### Slow Query Log

```sql
-- Enable slow query log
ALTER SYSTEM SET log_min_duration_statement = 1000;  -- Log queries > 1s

-- View slow queries
SELECT * FROM pg_stat_statements WHERE mean_exec_time > 1000;
```

### Query Analysis

```typescript
// Use EXPLAIN to analyze queries
const result = await prisma.$queryRaw`
  EXPLAIN ANALYZE SELECT * FROM markets WHERE status = 'active'
`
```

---

## Data Seeding Patterns

### Seed Script

```typescript
// prisma/seed.ts
async function main() {
  // Create test data
  await prisma.market.createMany({
    data: [
      { name: 'Market 1', status: 'active' },
      { name: 'Market 2', status: 'active' },
      { name: 'Market 3', status: 'inactive' }
    ]
  })
}
```

### Environment-Specific Seeds

```typescript
// Development seeds only
if (process.env.NODE_ENV === 'development') {
  await seedTestData()
}
```

---

## Common Database Anti-Patterns

### ❌ SELECT *

```typescript
// BAD: Fetches all columns
const markets = await prisma.market.findMany({ select: { id: true } })
// Actually fetches all columns despite select

// GOOD: Select specific columns
const markets = await prisma.market.findMany({
  select: { id: true, name: true, status: true }
})
```

### ❌ Queries in Loops

```typescript
// BAD: N queries
for (const id of ids) {
  const market = await prisma.market.findUnique({ where: { id } })
}

// GOOD: 1 query
const markets = await prisma.market.findMany({
  where: { id: { in: ids } }
})
```

### ❌ Missing Indexes

```typescript
// BAD: Query on unindexed column
const markets = await prisma.market.findMany({
  where: { status: 'active' }
})
// Full table scan if no index on status

// GOOD: Create index first
// CREATE INDEX idx_markets_status ON markets(status)
```

### ❌ Large Transactions

```typescript
// BAD: Transaction runs for too long
await db.$transaction(async (tx) => {
  for (const item of largeArray) {
    await tx.market.create({ data: item })
    await complexOperation(tx, item)
    // Transaction open for minutes!
  }
})

// GOOD: Break into smaller transactions
for (const chunk of chunks(largeArray, 100)) {
  await db.$transaction(async (tx) => {
    for (const item of chunk) {
      await tx.market.create({ data: item })
    }
  })
}
```
