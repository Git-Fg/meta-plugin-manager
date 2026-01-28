# State Management Patterns Reference

React state management patterns and best practices.

---

## useState Patterns

### Primitive State

```typescript
const [count, setCount] = useState(0)
const [name, setName] = useState('')
const [isLoading, setIsLoading] = useState(false)
```

### Object State

```typescript
interface FormData {
  name: string
  email: string
  message: string
}

const [formData, setFormData] = useState<FormData>({
  name: '',
  email: '',
  message: ''
})

// Update specific field
const updateField = (field: keyof FormData, value: string) => {
  setFormData(prev => ({ ...prev, [field]: value }))
}
```

### Functional Updates (CRITICAL)

**WHY**: Prevents stale closure bugs in async scenarios.

```typescript
// GOOD: Functional update
setCount(prev => prev + 1)
setCount(prev => prev * 2)

// BAD: Direct reference (can be stale)
setCount(count + 1)
setCount(count * 2)
```

---

## useReducer Patterns

### When to use useReducer

- Complex state logic
- State depends on previous state
- Multiple related state values
- Next state depends on action type

### Basic Counter Reducer

```typescript
type Action =
  | { type: 'INCREMENT' }
  | { type: 'DECREMENT' }
  | { type: 'SET'; payload: number }

function reducer(state: number, action: Action): number {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1
    case 'DECREMENT':
      return state - 1
    case 'SET':
      return action.payload
    default:
      return state
  }
}

const [count, dispatch] = useReducer(reducer, 0)
```

### Complex State Reducer

```typescript
interface State {
  items: Item[]
  loading: boolean
  error: string | null
  filter: string
}

type Action =
  | { type: 'FETCH_START' }
  | { type: 'FETCH_SUCCESS'; payload: Item[] }
  | { type: 'FETCH_ERROR'; payload: string }
  | { type: 'SET_FILTER'; payload: string }

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'FETCH_START':
      return { ...state, loading: true, error: null }
    case 'FETCH_SUCCESS':
      return { ...state, loading: false, items: action.payload }
    case 'FETCH_ERROR':
      return { ...state, loading: false, error: action.payload }
    case 'SET_FILTER':
      return { ...state, filter: action.payload }
    default:
      return state
  }
}
```

### Action Creators Pattern

```typescript
const actions = {
  fetchStart: () => ({ type: 'FETCH_START' as const }),
  fetchSuccess: (items: Item[]) => ({ type: 'FETCH_SUCCESS' as const, payload: items }),
  fetchError: (error: string) => ({ type: 'FETCH_ERROR' as const, payload: error }),
  setFilter: (filter: string) => ({ type: 'SET_FILTER' as const, payload: filter })
}

// Usage
dispatch(actions.fetchStart())
```

---

## useContext Patterns

### Basic Context Setup

```typescript
interface ThemeContextValue {
  theme: 'light' | 'dark'
  toggleTheme: () => void
}

const ThemeContext = createContext<ThemeContextValue | undefined>(undefined)

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light')

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light')
  }

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  )
}

export function useTheme() {
  const context = useContext(ThemeContext)
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider')
  }
  return context
}
```

### Context + Reducer Pattern

```typescript
interface State {
  user: User | null
  isLoading: boolean
}

type Action =
  | { type: 'SET_USER'; payload: User }
  | { type: 'CLEAR_USER' }
  | { type: 'SET_LOADING'; payload: boolean }

const AuthContext = createContext<{
  state: State
  dispatch: Dispatch<Action>
} | undefined>(undefined)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(reducer, {
    user: null,
    isLoading: false
  })

  return (
    <AuthContext.Provider value={{ state, dispatch }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider')
  }
  return context
}
```

### Optimizing Context Re-renders

**Problem**: Context value changes cause all consumers to re-render.

**Solution**: Split context or use useMemo.

```typescript
// Split contexts
const UserContext = createContext<User | null>(null)
const UserActionsContext = createContext<{
  login: (user: User) => void
  logout: () => void
} | undefined>(undefined)

export function UserProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)

  const login = useCallback((u: User) => setUser(u), [])
  const logout = useCallback(() => setUser(null), [])

  return (
    <UserContext.Provider value={user}>
      <UserActionsContext.Provider value={{ login, logout }}>
        {children}
      </UserActionsContext.Provider>
    </UserContext.Provider>
  )
}
```

---

## Custom State Hooks

### useToggle Hook

```typescript
export function useToggle(initialValue = false): [boolean, () => void] {
  const [value, setValue] = useState(initialValue)

  const toggle = useCallback(() => {
    setValue(v => !v)
  }, [])

  return [value, toggle]
}

// Usage
const [isOpen, toggle] = useToggle()
```

### useBoolean Hook

```typescript
export function useBoolean(initialValue = false) {
  const [value, setValue] = useState(initialValue)

  const setTrue = useCallback(() => setValue(true), [])
  const setFalse = useCallback(() => setValue(false), [])
  const toggle = useCallback(() => setValue(v => !v), [])

  return { value, setValue, setTrue, setFalse, toggle }
}

// Usage
const { value: isOpen, setTrue: open, setFalse: close, toggle } = useBoolean()
```

### useList Hook

```typescript
export function useList<T>(initial: T[] = []) {
  const [list, setList] = useState<T[]>(initial)

  const append = useCallback((item: T) => {
    setList(prev => [...prev, item])
  }, [])

  const remove = useCallback((index: number) => {
    setList(prev => prev.filter((_, i) => i !== index))
  }, [])

  const update = useCallback((index: number, item: T) => {
    setList(prev => prev.map((item, i) => i === index ? item : item))
  }, [])

  const clear = useCallback(() => {
    setList([])
  }, [])

  return { list, setList, append, remove, update, clear }
}
```

### useCounter Hook

```typescript
export function useCounter(initialValue = 0) {
  const [count, setCount] = useState(initialValue)

  const increment = useCallback(() => {
    setCount(prev => prev + 1)
  }, [])

  const decrement = useCallback(() => {
    setCount(prev => prev - 1)
  }, [])

  const reset = useCallback(() => {
    setCount(initialValue)
  }, [initialValue])

  const set = useCallback((value: number) => {
    setCount(value)
  }, [])

  return { count, increment, decrement, reset, set }
}
```

---

## URL State Patterns

### useSearchParams for Query State

```typescript
import { useSearchParams, useRouter } from 'next/navigation'

export function useQueryState(key: string) {
  const router = useRouter()
  const searchParams = useSearchParams()
  const value = searchParams.get(key) || ''

  const setValue = (newValue: string) => {
    const params = new URLSearchParams(searchParams)
    if (newValue) {
      params.set(key, newValue)
    } else {
      params.delete(key)
    }
    router.push(`?${params.toString()}`)
  }

  return [value, setValue] as const
}

// Usage
const [search, setSearch] = useQueryState('q')
```

### Hash State for Client-Only State

```typescript
export function useHashState<T>(key: string, initialValue: T): [T, (value: T) => void] {
  const [state, setState] = useState<T>(() => {
    const hash = window.location.hash.slice(1)
    const params = new URLSearchParams(hash)
    const value = params.get(key)
    return value ? JSON.parse(value) : initialValue
  })

  const setValue = (value: T) => {
    setState(value)
    const hash = window.location.hash.slice(1)
    const params = new URLSearchParams(hash)
    params.set(key, JSON.stringify(value))
    window.location.hash = params.toString()
  }

  return [state, setValue]
}
```

---

## Global State Options

### When to Use What

| Pattern | Best For | Scale |
|---------|----------|-------|
| useState | Component-local state | Small |
| useReducer | Complex component state | Medium |
| Context | Global app state (theme, auth) | Medium |
| Zustand/Jotai | Client global state, fast updates | Large |
| React Query | Server state, caching | Large |
| Redux | Very complex state, time-travel | Very Large |

### Zustand Pattern

```typescript
import { create } from 'zustand'

interface BearStore {
  bears: number
  increase: () => void
  decrease: () => void
}

export const useBearStore = create<BearStore>((set) => ({
  bears: 0,
  increase: () => set((state) => ({ bears: state.bears + 1 })),
  decrease: () => set((state) => ({ bears: state.bears - 1 }))
}))

// Usage
function BearCounter() {
  const bears = useBearStore(state => state.bears)
  const increase = useBearStore(state => state.increase)
  return <button onClick={increase}>{bears}</button>
}
```

### React Query Pattern (Server State)

```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'

function useMarkets() {
  return useQuery({
    queryKey: ['markets'],
    queryFn: () => fetch('/api/markets').then(r => r.json())
  })
}

function useCreateMarket() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (data: CreateMarketDto) =>
      fetch('/api/markets', {
        method: 'POST',
        body: JSON.stringify(data)
      }).then(r => r.json()),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['markets'] })
    }
  })
}
```

---

## State Management Anti-Patterns

### ❌ useEffect for Derived State

```typescript
// BAD: useEffect for derived state
useEffect(() => {
  setFullName(`${firstName} ${lastName}`)
}, [firstName, lastName])

// GOOD: Derive during render
const fullName = `${firstName} ${lastName}`
```

### ❌ Duplication in State and URL

```typescript
// BAD: Separate state and URL param
const [page, setPage] = useState(1)
useEffect(() => {
  router.push(`?page=${page}`)
}, [page, router])

// GOOD: URL as single source of truth
const page = Number(searchParams.get('page') || '1')
const setPage = (p: number) => {
  const params = new URLSearchParams(searchParams)
  params.set('page', String(p))
  router.push(`?${params.toString()}`)
}
```

### ❌ Giant State Objects

```typescript
// BAD: Everything in one state object
const [form, setForm] = useState({
  // 50 fields...
})

// GOOD: Split into logical groups
const [personalInfo, setPersonalInfo] = useState(...)
const [address, setAddress] = useState(...)
const [preferences, setPreferences] = useState(...)
```
