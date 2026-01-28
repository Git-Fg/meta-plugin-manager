# Component Patterns Reference

Detailed React component architecture and design patterns.

---

## Composition Patterns

### Compound Components

**WHY**: Flexible API, shared state, intuitive JSX.

```typescript
interface TabsContextValue {
  activeTab: string
  setActiveTab: (tab: string) => void
}

const TabsContext = createContext<TabsContextValue | undefined>(undefined)

export function Tabs({ children, defaultTab }: {
  children: React.ReactNode
  defaultTab: string
}) {
  const [activeTab, setActiveTab] = useState(defaultTab)

  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      {children}
    </TabsContext.Provider>
  )
}

export function TabList({ children }: { children: React.ReactNode }) {
  return <div className="tab-list">{children}</div>
}

export function Tab({ id, children }: { id: string; children: React.ReactNode }) {
  const context = useContext(TabsContext)
  if (!context) throw new Error('Tab must be used within Tabs')

  return (
    <button
      className={context.activeTab === id ? 'active' : ''}
      onClick={() => context.setActiveTab(id)}
    >
      {children}
    </button>
  )
}

export function TabPanel({ id, children }: { id: string; children: React.ReactNode }) {
  const context = useContext(TabsContext)
  if (!context) throw new Error('TabPanel must be used within Tabs')

  if (context.activeTab !== id) return null
  return <div className="tab-panel">{children}</div>
}

// Usage
<Tabs defaultTab="overview">
  <TabList>
    <Tab id="overview">Overview</Tab>
    <Tab id="details">Details</Tab>
  </TabList>
  <TabPanel id="overview">
    {/* Overview content */}
  </TabPanel>
  <TabPanel id="details">
    {/* Details content */}
  </TabPanel>
</Tabs>
```

### Slot Pattern

**WHY**: Flexible content placement, parent controls layout.

```typescript
interface CardProps {
  header?: React.ReactNode
  footer?: React.ReactNode
  children: React.ReactNode
}

export function Card({ header, footer, children }: CardProps) {
  return (
    <div className="card">
      {header && <div className="card-header">{header}</div>}
      <div className="card-body">{children}</div>
      {footer && <div className="card-footer">{footer}</div>}
    </div>
  )
}

// Usage
<Card
  header={<h2>Title</h2>}
  footer={<button>Action</button>}
>
  Content here
</Card>
```

### Render Props

**WHY**: Share component logic, flexible rendering.

```typescript
interface MouseTrackerProps {
  render: (position: { x: number; y: number }) => React.ReactNode
}

export function MouseTracker({ render }: MouseTrackerProps) {
  const [position, setPosition] = useState({ x: 0, y: 0 })

  const handleMouseMove = (e: React.MouseEvent) => {
    setPosition({ x: e.clientX, y: e.clientY })
  }

  return (
    <div onMouseMove={handleMouseMove}>
      {render(position)}
    </div>
  )
}

// Usage
<MouseTracker render={({ x, y }) => (
  <div>Mouse position: {x}, {y}</div>
)} />
```

---

## Container/Presentational Pattern

### Presentational Component

```typescript
interface MarketCardProps {
  market: Market
  onSelect?: (market: Market) => void
}

export function MarketCard({ market, onSelect }: MarketCardProps) {
  return (
    <div className="market-card" onClick={() => onSelect?.(market)}>
      <h3>{market.name}</h3>
      <p>{market.description}</p>
      <span className={`status status-${market.status}`}>
        {market.status}
      </span>
    </div>
  )
}
```

### Container Component

```typescript
export function MarketCardContainer({ marketId }: { marketId: string }) {
  const market = useMarket(marketId)
  const router = useRouter()

  if (!market) return <div>Loading...</div>

  return (
    <MarketCard
      market={market}
      onSelect={(m) => router.push(`/markets/${m.id}`)}
    />
  )
}
```

---

## Higher-Order Components

### withAuth Pattern

```typescript
interface WithAuthProps {
  user: User
}

function withAuth<P extends object>(
  Component: React.ComponentType<P & WithAuthProps>
) {
  return function AuthenticatedComponent(props: P) {
    const user = useAuth()

    if (!user) {
      return <div>Please log in</div>
    }

    return <Component {...props} user={user} />
  }
}

// Usage
const ProtectedDashboard = withAuth(Dashboard)
```

### withLoading Pattern

```typescript
interface WithLoadingProps {
  loading: boolean
}

function withLoading<P extends object>(
  Component: React.ComponentType<P>,
  fallback: React.ReactNode = <div>Loading...</div>
) {
  return function LoadingComponent({ loading, ...props }: P & WithLoadingProps) {
    if (loading) {
      return fallback
    }
    return <Component {...(props as P)} />
  }
}

// Usage
const MarketListWithLoading = withLoading(MarketList, <MarketSkeleton />)
```

---

## Custom Hook Patterns

### useFetch Hook

```typescript
interface UseFetchResult<T> {
  data: T | null
  loading: boolean
  error: Error | null
  refetch: () => Promise<void>
}

export function useFetch<T>(url: string): UseFetchResult<T> {
  const [data, setData] = useState<T | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  const fetchData = useCallback(async () => {
    setLoading(true)
    setError(null)

    try {
      const response = await fetch(url)
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`)
      }
      const json = await response.json()
      setData(json)
    } catch (err) {
      setError(err as Error)
    } finally {
      setLoading(false)
    }
  }, [url])

  useEffect(() => {
    fetchData()
  }, [fetchData])

  return { data, loading, error, refetch: fetchData }
}
```

### useLocalStorage Hook

```typescript
export function useLocalStorage<T>(
  key: string,
  initialValue: T
): [T, (value: T | ((prev: T) => T)) => void] {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key)
      return item ? JSON.parse(item) : initialValue
    } catch (error) {
      console.error(error)
      return initialValue
    }
  })

  const setValue = useCallback((value: T | ((prev: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value
      setStoredValue(valueToStore)
      window.localStorage.setItem(key, JSON.stringify(valueToStore))
    } catch (error) {
      console.error(error)
    }
  }, [key, storedValue])

  return [storedValue, setValue]
}
```

### usePrevious Hook

```typescript
export function usePrevious<T>(value: T): T | undefined {
  const ref = useRef<T>()
  const [current, setCurrent] = useState(value)

  useEffect(() => {
    ref.current = current
    setCurrent(value)
  }, [value, current])

  return ref.current
}
```

---

## Error Boundary Pattern

```typescript
interface ErrorBoundaryState {
  hasError: boolean
  error: Error | null
}

interface ErrorBoundaryProps {
  children: React.ReactNode
  fallback?: React.ComponentType<{ error: Error }>
}

export class ErrorBoundary extends React.Component<
  ErrorBoundaryProps,
  ErrorBoundaryState
> {
  constructor(props: ErrorBoundaryProps) {
    super(props)
    this.state = { hasError: false, error: null }
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error boundary caught:', error, errorInfo)
  }

  render() {
    if (this.state.hasError) {
      const FallbackComponent = this.props.fallback

      if (FallbackComponent && this.state.error) {
        return <FallbackComponent error={this.state.error} />
      }

      return (
        <div className="error-fallback">
          <h2>Something went wrong</h2>
          <p>{this.state.error?.message}</p>
          <button onClick={() => this.setState({ hasError: false })}>
            Try again
          </button>
        </div>
      )
    }

    return this.props.children
  }
}
```

---

## Component Best Practices

### 1. Single Responsibility

Each component should do one thing well.

```typescript
// GOOD: Single responsibility
<UserAvatar src={user.avatar} />
<UserStats posts={user.posts.length} followers={user.followers.length} />

// BAD: Multiple responsibilities
<UserCard user={user} showAvatar showStats showSettings />
```

### 2. Props Interface

Always define props interface for type safety.

```typescript
interface ButtonProps {
  children: React.ReactNode
  onClick?: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary' | 'danger'
  size?: 'sm' | 'md' | 'lg'
}

export function Button({ children, onClick, disabled, variant = 'primary', size = 'md' }: ButtonProps) {
  // ...
}
```

### 3. Default Props

Use destructuring with defaults for optional props.

```typescript
export function Modal({
  isOpen = false,
  onClose = () => {},
  title = '',
  children
}: {
  isOpen?: boolean
  onClose?: () => void
  title?: string
  children: React.ReactNode
}) {
  // ...
}
```

### 4. Children Prop

Use `children` prop for flexible composition.

```typescript
interface CardProps {
  children: React.ReactNode
  className?: string
}

export function Card({ children, className = '' }: CardProps) {
  return <div className={`card ${className}`}>{children}</div>
}
```

### 5. Ref Forwarding

Use forwardRef when component needs ref access.

```typescript
export const Button = React.forwardRef<
  HTMLButtonElement,
  ButtonProps
>(({ children, onClick, disabled }, ref) => {
  return (
    <button
      ref={ref}
      onClick={onClick}
      disabled={disabled}
      className="btn"
    >
      {children}
    </button>
  )
})

Button.displayName = 'Button'
```
