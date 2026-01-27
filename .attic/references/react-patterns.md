# React Patterns Reference

React and Next.js specific coding patterns and best practices.

---

## Component Patterns

### Functional Components with Types

```typescript
interface ButtonProps {
  children: React.ReactNode
  onClick: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary'
}

export function Button({
  children,
  onClick,
  disabled = false,
  variant = 'primary'
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  )
}
```

### Custom Hooks Pattern

```typescript
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value)
    }, delay)

    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}
```

### Compound Components

```typescript
interface CardContextValue {
  variant: 'default' | 'outlined'
}

const CardContext = createContext<CardContextValue | undefined>(undefined)

export function Card({
  children,
  variant = 'default'
}: { children: React.ReactNode; variant?: 'default' | 'outlined' }) {
  return (
    <CardContext.Provider value={{ variant }}>
      <div className={`card card-${variant}`}>{children}</div>
    </CardContext.Provider>
  )
}

export function CardHeader({ children }: { children: React.ReactNode }) {
  const context = useContext(CardContext)
  return <div className="card-header">{children}</div>
}
```

## State Management Patterns

### useState with Functional Updates

```typescript
// GOOD: Functional update prevents stale closures
const [count, setCount] = useState(0)
setCount(prev => prev + 1)

// GOOD: For object state
const [user, setUser] = useState<User | null>(null)
setUser(prev => ({ ...prev, name: 'New Name' }))
```

### useReducer for Complex State

```typescript
type Action =
  | { type: 'SET_MARKETS'; payload: Market[] }
  | { type: 'SELECT_MARKET'; payload: Market }
  | { type: 'SET_LOADING'; payload: boolean }

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'SET_MARKETS':
      return { ...state, markets: action.payload }
    case 'SELECT_MARKET':
      return { ...state, selectedMarket: action.payload }
    case 'SET_LOADING':
      return { ...state, loading: action.payload }
    default:
      return state
  }
}

const [state, dispatch] = useReducer(reducer, initialState)
```

### Context + Reducer Pattern

```typescript
const MarketContext = createContext<{
  state: State
  dispatch: Dispatch<Action>
} | undefined>(undefined)

export function MarketProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(reducer, initialState)

  return (
    <MarketContext.Provider value={{ state, dispatch }}>
      {children}
    </MarketContext.Provider>
  )
}
```

## Performance Patterns

### React.memo for Pure Components

```typescript
export const MarketCard = React.memo<MarketCardProps>(({ market }) => {
  return (
    <div className="market-card">
      <h3>{market.name}</h3>
      <p>{market.description}</p>
    </div>
  )
}, (prevProps, nextProps) => {
  // Custom comparison
  return prevProps.market.id === nextProps.market.id
})
```

### useMemo for Expensive Computations

```typescript
const sortedMarkets = useMemo(() => {
  return markets.sort((a, b) => b.volume - a.volume)
}, [markets])
```

### useCallback for Stable Function References

```typescript
const handleSearch = useCallback((query: string) => {
  setSearchQuery(query)
}, [])
```

## Effect Patterns

### Cleanup Effects

```typescript
useEffect(() => {
  const subscription = dataSource.subscribe()

  return () => {
    subscription.unsubscribe()
  }
}, [dataSource])
```

### Dependent Effects

```typescript
// GOOD: Run when userId changes
useEffect(() => {
  fetchUser(userId).then(setUser)
}, [userId])

// BAD: Missing dependency
useEffect(() => {
  fetchUser(userId).then(setUser)
}, []) // Missing userId - will use stale value
```

### Skip Initial Render

```typescript
useEffect(() => {
  if (isInitialMount.current) {
    isInitialMount.current = false
    return
  }

  // Only run on updates, not initial mount
  console.log('Component updated')
}, [dependency])
```

## Form Patterns

### Controlled Components

```typescript
export function CreateMarketForm() {
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    endDate: ''
  })

  const handleChange = (field: string) => (e: ChangeEvent<HTMLInputElement>) => {
    setFormData(prev => ({ ...prev, [field]: e.target.value }))
  }

  return (
    <form>
      <input value={formData.name} onChange={handleChange('name')} />
      <textarea value={formData.description} onChange={handleChange('description')} />
      <input type="date" value={formData.endDate} onChange={handleChange('endDate')} />
    </form>
  )
}
```

### Form Validation Pattern

```typescript
const [errors, setErrors] = useState<Record<string, string>>({})

const validate = (): boolean => {
  const newErrors: Record<string, string> = {}

  if (!formData.name.trim()) {
    newErrors.name = 'Name is required'
  } else if (formData.name.length > 200) {
    newErrors.name = 'Name must be under 200 characters'
  }

  setErrors(newErrors)
  return Object.keys(newErrors).length === 0
}
```

## Next.js Specific Patterns

### Server Components (App Router)

```typescript
// app/markets/page.tsx
async function MarketsPage() {
  const markets = await fetchMarkets() // Server-side fetch

  return (
    <div>
      <MarketList markets={markets} />
    </div>
  )
}
```

### Client Components

```typescript
'use client'

export function MarketList({ markets }: { markets: Market[] }) {
  const [filter, setFilter] = useState('')

  // Client-side interactivity
  return (
    <div>
      <input value={filter} onChange={e => setFilter(e.target.value)} />
      {markets.filter(m => m.name.includes(filter)).map(m => (
        <MarketCard key={m.id} market={m} />
      ))}
    </div>
  )
}
```

### Server Actions

```typescript
'use server'

export async function createMarket(formData: FormData) {
  const session = await auth()
  if (!session) throw new Error('Unauthorized')

  const validated = CreateMarketSchema.parse({
    name: formData.get('name'),
    description: formData.get('description')
  })

  await db.markets.create({ data: validated })
  revalidatePath('/markets')
}
```

## Error Boundary Pattern

```typescript
class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  { hasError: boolean; error: Error | null }
> {
  state = { hasError: false, error: null }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error boundary caught:', error, errorInfo)
  }

  render() {
    if (this.state.hasError) {
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
