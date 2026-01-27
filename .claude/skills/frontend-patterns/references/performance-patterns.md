# Performance Patterns Reference

React and Next.js performance optimization patterns.

---

## Memoization Patterns

### useMemo Guidelines

**WHY**: Prevent expensive recalculations on every render.

**Use when**:
- Computation takes > 10ms
- Input array is large
- Result used in render

```typescript
// GOOD: Memoize expensive sort
const sortedMarkets = useMemo(() => {
  console.log('Sorting markets...')
  return markets.sort((a, b) => b.volume - a.volume)
}, [markets])

// BAD: Memoizing simple operation
const doubled = useMemo(() => count * 2, [count])  // Faster to compute
```

### useCallback Guidelines

**WHY**: Prevent function recreation, important for props passed to memoized children.

**Use when**:
- Function passed to memoized child
- Function used in useEffect dependency
- Function used as event handler in many places

```typescript
// GOOD: Memoize for memoized child
const handleSearch = useCallback((query: string) => {
  onSearch(query)
}, [onSearch])

// BAD: useCallback when not needed
const handleClick = useCallback(() => {
  console.log('clicked')
}, [])  // Function reference stable without useCallback
```

### React.memo Guidelines

**WHY**: Prevent unnecessary re-renders of pure components.

**Use when**:
- Component renders often
- Props are usually the same
- Component render is expensive

```typescript
// GOOD: Memoize expensive component
export const MarketCard = React.memo<MarketCardProps>(({ market }) => {
  // Complex rendering logic
  return (
    <div>
      {/* ... */}
    </div>
  )
}, (prevProps, nextProps) => {
  // Custom comparison
  return prevProps.market.id === nextProps.market.id
})
```

**Recognition**: "Does this optimization actually help?" → Profile first.

---

## Code Splitting Patterns

### Route-Based Splitting

```typescript
// Automatic with Next.js App Router
// Each page is automatically code-split
// app/dashboard/page.tsx → Separate chunk
// app/settings/page.tsx → Separate chunk
```

### Dynamic Imports

```typescript
import { lazy, Suspense } from 'react'

const HeavyChart = lazy(() => import('./HeavyChart'))
const AdminPanel = lazy(() => import('./AdminPanel'))

export function Dashboard() {
  const [showAdmin, setShowAdmin] = useState(false)

  return (
    <div>
      <Suspense fallback={<ChartSkeleton />}>
        <HeavyChart data={data} />
      </Suspense>

      {showAdmin && (
        <Suspense fallback={<div>Loading admin...</div>}>
          <AdminPanel />
        </Suspense>
      )}
    </div>
  )
}
```

### Named Exports

```typescript
// Dynamic import with named exports
const { DataTable } = await import('./DataTable')
```

---

## List Virtualization

### When to Virtualize

**Use virtualization when**:
- Rendering 100+ items
- Each item is complex (> 100 DOM nodes)
- Lists cause laggy scrolling

**Don't virtualize when**:
- Few items (< 50)
- Simple items
- Need smooth scrolling animations

### TanStack Virtual Pattern

```typescript
import { useVirtualizer } from '@tanstack/react-virtual'

export function VirtualList({ items }: { items: Item[] }) {
  const parentRef = useRef<HTMLDivElement>(null)

  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 100,  // Estimated row height
    overscan: 5  // Extra items to render
  })

  return (
    <div ref={parentRef} style={{ height: '600px', overflow: 'auto' }}>
      <div
        style={{
          height: `${virtualizer.getTotalSize()}px`,
          position: 'relative'
        }}
      >
        {virtualizer.getVirtualItems().map(virtualRow => (
          <div
            key={virtualRow.index}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: `${virtualRow.size}px`,
              transform: `translateY(${virtualRow.start}px)`
            }}
          >
            <ListItem item={items[virtualRow.index]} />
          </div>
        ))}
      </div>
    </div>
  )
}
```

### Dynamic Row Heights

```typescript
const virtualizer = useVirtualizer({
  count: items.length,
  getScrollElement: () => parentRef.current,
  estimateSize: () => 100,  // Initial estimate
  measureElement: (element) => {
    // Measure actual height after render
    return element?.getBoundingClientRect().height ?? 100
  }
})
```

---

## Image Optimization

### Next.js Image Component

```typescript
import Image from 'next/image'

export function MarketImage({ src, alt }: { src: string; alt: string }) {
  return (
    <Image
      src={src}
      alt={alt}
      width={400}
      height={300}
      placeholder="blur"
      blurDataURL="data:image/jpeg;base64,/9j/4AAQSkZJRg..."
    />
  )
}
```

### Lazy Loading Images

```typescript
export function ImageGallery({ images }: { images: string[] }) {
  return (
    <div>
      {images.map((src, i) => (
        <img
          key={src}
          src={src}
          loading={i < 3 ? 'eager' : 'lazy'}  // First 3 eager
          alt=""
        />
      ))}
    </div>
  )
}
```

---

## Font Optimization

### next/font Usage

```typescript
import { Inter } from 'next/font/google'

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: true
})

export function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html className={inter.className}>
      <body>{children}</body>
    </html>
  )
}
```

---

## Data Fetching Optimization

### Parallel Queries

```typescript
import { useQuery } from '@tanstack/react-query'

export function useDashboardData() {
  // Run in parallel
  const markets = useQuery({ queryKey: ['markets'], queryFn: fetchMarkets })
  const stats = useQuery({ queryKey: ['stats'], queryFn: fetchStats })
  const notifications = useQuery({ queryKey: ['notifications'], queryFn: fetchNotifications })

  return { markets, stats, notifications }
}
```

### Dependent Queries

```typescript
export function useMarketDetails(marketId: string) {
  // First query
  const market = useQuery({
    queryKey: ['market', marketId],
    queryFn: () => fetchMarket(marketId)
  })

  // Dependent query - only runs when market is loaded
  const related = useQuery({
    queryKey: ['related', marketId],
    queryFn: () => fetchRelatedMarkets(market.data?.category),
    enabled: !!market.data  // Only run when market exists
  })

  return { market, related }
}
```

### Prefetching

```typescript
export function MarketLink({ marketId, children }: { marketId: string; children: React.ReactNode }) {
  const queryClient = useQueryClient()

  const prefetch = () => {
    queryClient.prefetchQuery({
      queryKey: ['market', marketId],
      queryFn: () => fetchMarket(marketId)
    })
  }

  return (
    <Link href={`/markets/${marketId}`} onMouseEnter={prefetch}>
      {children}
    </Link>
  )
}
```

---

## Bundle Optimization

### Dynamic Imports for Large Libraries

```typescript
// GOOD: Dynamic import for heavy chart library
const Chart = dynamic(() => import('recharts').then(mod => mod.ResponsiveContainer), {
  loading: () => <ChartSkeleton />,
  ssr: false  // Skip SSR for client-only libs
})
```

### Tree Shaking

```typescript
// GOOD: Import only what you need
import { debounce } from 'lodash-es'

// BAD: Import entire library
import _ from 'lodash'
```

---

## Performance Monitoring

### useDebugValue for Custom Hooks

```typescript
function useWindowSize() {
  const [size, setSize] = useState({ width: 0, height: 0 })

  useDebugValue(size, (value) => {
    return `Size: ${value.width}x${value.height}`
  })

  useEffect(() => {
    const updateSize = () => {
      setSize({ width: window.innerWidth, height: window.innerHeight })
    }
    window.addEventListener('resize', updateSize)
    updateSize()
    return () => window.removeEventListener('resize', updateSize)
  }, [])

  return size
}
```

### React DevTools Profiler

```typescript
import { Profiler, ProfilerOnRenderCallback } from 'react'

const onRenderCallback: ProfilerOnRenderCallback = (
  id, phase, actualDuration, baseDuration, startTime, commitTime
) => {
  console.log(`${id} ${phase} took ${actualDuration}ms`)
}

export function ProfiledApp() {
  return (
    <Profiler id="App" onRender={onRenderCallback}>
      <App />
    </Profiler>
  )
}
```

---

## Performance Anti-Patterns

### ❌ Over-Memoization

```typescript
// BAD: Memoizing everything
const doubled = useMemo(() => count * 2, [count])
const greeting = useMemo(() => `Hello, ${name}`, [name])

// GOOD: Only memoize expensive operations
const expensive = useMemo(() => complexCalculation(data), [data])
```

### ❌ Inline Object/Array Creation

```typescript
// BAD: New array on every render
<Component items={[...items]} />

// GOOD: Stable reference
const memoizedItems = useMemo(() => [...items], [items])
<Component items={memoizedItems} />
```

### ❌ Anonymous Functions in Render

```typescript
// BAD: New function on every render
<Button onClick={() => handleClick(item)} />

// GOOD: Stable reference
const handleClickItem = useCallback(() => handleClick(item), [item, handleClick])
<Button onClick={handleClickItem} />
```

### ❌ Unnecessary Re-renders from Context

```typescript
// BAD: Entire context changes
<ThemeContext.Provider value={{ theme, setTheme }}>

// GOOD: Memoized context value
const contextValue = useMemo(() => ({ theme, setTheme }), [theme, setTheme])
<ThemeContext.Provider value={contextValue}>
```

---

## Performance Checklist

Before considering performance optimization complete:

- [ ] Profiled before optimizing (not guessing)
- [ ] Large lists use virtualization
- [ ] Heavy components are lazy-loaded
- [ ] Images use Next.js Image component
- [ ] Fonts use next/font
- [ ] Queries run in parallel when possible
- [ ] Dependent queries use `enabled` option
- [ ] Only memoize expensive operations
- [ ] Stable function references for callbacks
- [ ] Context values are memoized
