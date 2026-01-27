---
name: frontend-patterns
description: Modern frontend development patterns for React 19, Next.js 15, and performance optimization. Use when: building React components, optimizing performance, designing state management, implementing forms.
---

# Frontend Development Patterns

Modern frontend patterns for React 19, Next.js 15, and performant user interfaces.

---

## Quick Navigation

| If you are... | MANDATORY READ WHEN... | File |
|---------------|------------------------|------|
| Building components | CREATING COMPONENTS | `references/component-patterns.md` |
| Managing state | DESIGNING STATE | `references/state-patterns.md` |
| Optimizing performance | IMPROVING PERFORMANCE | `references/performance-patterns.md` |
| Handling forms | BUILDING FORMS | `references/form-patterns.md` |

---

## React 19 & Next.js 15 Core Patterns

### Server vs Client Components

**WHY**: Server Components reduce bundle size, improve performance, enable direct database access.

**Server Components** (default in Next.js App Router):
```typescript
// No 'use client' directive = Server Component
async function MarketsPage() {
  const markets = await db.markets.findMany() // Direct DB access!
  return <MarketList markets={markets} />
}
```

**Client Components** (when needed):
```typescript
'use client'

export function MarketFilter({ onFilter }: { onFilter: (filter: string) => void }) {
  const [value, setValue] = useState('')
  return <input value={value} onChange={e => setValue(e.target.value)} />
}
```

**Recognition**: "Does this need useState/useEffect/event handlers?" → Use Client Component. Otherwise, Server Component.

### Server Actions

**WHY**: Simplifies mutations, progressive enhancement, no separate API routes.

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

**Usage in component**:
```typescript
<form action={createMarket}>
  <input name="name" />
  <textarea name="description" />
  <button type="submit">Create</button>
</form>
```

### Parallel Routes & Intercepting Routes

**WHY**: Complex layouts, modal states, independent page sections.

```typescript
// app/dashboard/@settings/layout.tsx
export default function SettingsLayout({ children }) {
  return (
    <div>
      <nav>{/* Settings nav */}</nav>
      {children}
    </div>
  )
}
```

---

## Component Architecture Patterns

### Composition Over Inheritance

**WHY**: Flexible, reusable, easier to maintain.

```typescript
// GOOD: Compound components
<Card>
  <CardHeader>Title</CardHeader>
  <CardBody>Content</CardBody>
</Card>

// BAD: Complex props
<Card header="Title" body="Content" showHeader={true} />
```

### Render Props Pattern

**WHY**: Share component logic, flexible rendering.

```typescript
interface DataLoaderProps<T> {
  url: string
  children: (data: T | null, loading: boolean, error: Error | null) => React.ReactNode
}

export function DataLoader<T>({ url, children }: DataLoaderProps<T>) {
  const [data, setData] = useState<T | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false))
  }, [url])

  return <>{children(data, loading, error)}</>
}
```

---

## Performance Patterns

### Virtualization for Long Lists

**WHY**: Rendering 1000+ items causes lag. Virtualization renders only visible items.

```typescript
import { useVirtualizer } from '@tanstack/react-virtual'

export function VirtualMarketList({ markets }: { markets: Market[] }) {
  const parentRef = useRef<HTMLDivElement>(null)

  const virtualizer = useVirtualizer({
    count: markets.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 100,
    overscan: 5
  })

  return (
    <div ref={parentRef} style={{ height: '600px', overflow: 'auto' }}>
      <div style={{ height: `${virtualizer.getTotalSize()}px`, position: 'relative' }}>
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
            <MarketCard market={markets[virtualRow.index]} />
          </div>
        ))}
      </div>
    </div>
  )
}
```

### Code Splitting & Lazy Loading

**WHY**: Reduce initial bundle size, load code on-demand.

```typescript
import { lazy, Suspense } from 'react'

const HeavyChart = lazy(() => import('./HeavyChart'))
const ThreeJsBackground = lazy(() => import('./ThreeJsBackground'))

export function Dashboard() {
  return (
    <div>
      <Suspense fallback={<ChartSkeleton />}>
        <HeavyChart data={data} />
      </Suspense>
      <Suspense fallback={null}>
        <ThreeJsBackground />
      </Suspense>
    </div>
  )
}
```

### Memoization Guidelines

**WHY**: Prevent unnecessary re-renders, but don't over-optimize.

**Use useMemo when**:
- Expensive computation (> 10ms)
- Derived data from large arrays
- Complex filtering/sorting

**Use useCallback when**:
- Function passed to memoized child
- Function used as dependency in useEffect
- Function used in event handlers passed to many children

**Use React.memo when**:
- Pure component with expensive render
- Child re-renders frequently when props haven't changed

**Recognition**: "Is this optimization actually needed?" → Profile first, optimize second.

---

## State Management Patterns

### Context + Reducer for Complex State

**WHY**: Related state updates, complex state logic, global state needed.

```typescript
interface State {
  markets: Market[]
  selectedMarket: Market | null
  loading: boolean
}

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

const MarketContext = createContext<{
  state: State
  dispatch: Dispatch<Action>
} | undefined>(undefined)

export function MarketProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(reducer, {
    markets: [],
    selectedMarket: null,
    loading: false
  })

  return (
    <MarketContext.Provider value={{ state, dispatch }}>
      {children}
    </MarketContext.Provider>
  )
}
```

### URL State for Shareable State

**WHY**: State in URL = shareable, bookmarkable, refreshable.

```typescript
function SearchResults() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const query = searchParams.get('q') || ''

  const updateQuery = (q: string) => {
    const params = new URLSearchParams(searchParams)
    if (q) params.set('q', q)
    else params.delete('q')
    router.push(`/search?${params.toString()}`)
  }

  return <input value={query} onChange={e => updateQuery(e.target.value)} />
}
```

---

## Form Patterns

### Controlled Components with Validation

**WHY**: Real-time validation, better UX, type-safe.

```typescript
interface FormData {
  name: string
  description: string
  endDate: string
}

interface FormErrors {
  name?: string
  description?: string
  endDate?: string
}

export function CreateMarketForm() {
  const [formData, setFormData] = useState<FormData>({
    name: '',
    description: '',
    endDate: ''
  })

  const [errors, setErrors] = useState<FormErrors>({})

  const validate = (): boolean => {
    const newErrors: FormErrors = {}

    if (!formData.name.trim()) {
      newErrors.name = 'Name is required'
    } else if (formData.name.length > 200) {
      newErrors.name = 'Name must be under 200 characters'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!validate()) return
    await createMarket(formData)
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        value={formData.name}
        onChange={e => setFormData(prev => ({ ...prev, name: e.target.value }))}
      />
      {errors.name && <span className="error">{errors.name}</span>}
    </form>
  )
}
```

### Server Actions with Forms

**WHY**: Progressive enhancement, no client-side JS needed.

```typescript
export function CreateMarketForm() {
  return (
    <form action={createMarket}>
      <input name="name" required minLength={1} maxLength={200} />
      <textarea name="description" required />
      <button type="submit">Create</button>
    </form>
  )
}
```

---

## Accessibility Patterns

### Keyboard Navigation

**WHY**: Not everyone uses a mouse. Keyboard navigation is essential.

```typescript
export function Dropdown({ options, onSelect }: DropdownProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [activeIndex, setActiveIndex] = useState(0)

  const handleKeyDown = (e: React.KeyboardEvent) => {
    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault()
        setActiveIndex(i => Math.min(i + 1, options.length - 1))
        break
      case 'ArrowUp':
        e.preventDefault()
        setActiveIndex(i => Math.max(i - 1, 0))
        break
      case 'Enter':
        e.preventDefault()
        onSelect(options[activeIndex])
        setIsOpen(false)
        break
      case 'Escape':
        setIsOpen(false)
        break
    }
  }

  return (
    <div
      role="combobox"
      aria-expanded={isOpen}
      onKeyDown={handleKeyDown}
    >
      {/* Dropdown implementation */}
    </div>
  )
}
```

### Focus Management

**WHY**: Screen readers rely on focus. Focus traps and restoration matter.

```typescript
export function Modal({ isOpen, onClose, children }: ModalProps) {
  const modalRef = useRef<HTMLDivElement>(null)
  const previousFocusRef = useRef<HTMLElement | null>(null)

  useEffect(() => {
    if (isOpen) {
      previousFocusRef.current = document.activeElement as HTMLElement
      modalRef.current?.focus()
    } else {
      previousFocusRef.current?.focus()
    }
  }, [isOpen])

  return isOpen ? (
    <div
      ref={modalRef}
      role="dialog"
      aria-modal="true"
      tabIndex={-1}
      onKeyDown={e => e.key === 'Escape' && onClose()}
    >
      {children}
    </div>
  ) : null
}
```

---

## Anti-Patterns to Avoid

### ❌ Giant Components

```typescript
// BAD: 500+ lines
export function GiantComponent() {
  // ... 500 lines of logic
}

// GOOD: Break into smaller components
export function Page() {
  return (
    <>
      <Header />
      <Content />
      <Footer />
    </>
  )
}
```

### ❌ Prop Drilling

```typescript
// BAD: Passing props through 5 levels
<Page user={user}>
  <Header user={user}>
    <Nav user={user}>
      <UserMenu user={user} />
    </Nav>
  </Header>
</Page>

// GOOD: Use Context
const UserContext = createContext({ user: null })
```

### ❌ useEffect for Everything

```typescript
// BAD: Using useEffect for derived state
useEffect(() => {
  setFullName(`${firstName} ${lastName}`)
}, [firstName, lastName])

// GOOD: Derive during render
const fullName = `${firstName} ${lastName}`
```

---

## Verification Checklist

Before considering UI work complete:

- [ ] Server vs Client component choice is intentional
- [ ] No prop drilling (use Context for shared state)
- [ ] Large lists use virtualization
- [ ] Heavy components are lazy-loaded
- [ ] Forms have validation
- [ ] Keyboard navigation works
- [ ] Focus management is correct
- [ ] No unnecessary re-renders (profiled)
- [ ] Accessibility attributes present
- [ ] Mobile-responsive design

---

## Integration with Other Skills

This skill integrates with:
- `coding-standards` - General TypeScript/JavaScript patterns
- `tdd-workflow` - Testing patterns for components
- `verify` - Quality gate verification

**Recognition**: "Am I using WHY-based patterns?" → Every pattern should have a clear rationale.
