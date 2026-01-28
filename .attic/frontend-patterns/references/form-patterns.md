# Form Patterns Reference

Form handling, validation, and submission patterns in React.

---

## Controlled Component Patterns

### Basic Controlled Input

```typescript
export function TextInput({ value, onChange }: {
  value: string
  onChange: (value: string) => void
}) {
  return (
    <input
      type="text"
      value={value}
      onChange={e => onChange(e.target.value)}
    />
  )
}
```

### Object State Form

```typescript
interface FormData {
  name: string
  email: string
  message: string
}

export function ContactForm() {
  const [formData, setFormData] = useState<FormData>({
    name: '',
    email: '',
    message: ''
  })

  const handleChange = (field: keyof FormData) => (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData(prev => ({ ...prev, [field]: e.target.value }))
  }

  return (
    <form>
      <input
        name="name"
        value={formData.name}
        onChange={handleChange('name')}
      />
      <input
        name="email"
        value={formData.email}
        onChange={handleChange('email')}
      />
      <textarea
        name="message"
        value={formData.message}
        onChange={handleChange('message')}
      />
    </form>
  )
}
```

---

## Form Validation Patterns

### Real-Time Validation

```typescript
interface FormErrors {
  name?: string
  email?: string
  message?: string
}

export function ValidatedForm() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: ''
  })
  const [errors, setErrors] = useState<FormErrors>({})
  const [touched, setTouched] = useState<Record<string, boolean>>({})

  const validate = (field?: keyof FormData): boolean => {
    const newErrors: FormErrors = {}

    if (!field || field === 'name') {
      if (!formData.name.trim()) {
        newErrors.name = 'Name is required'
      } else if (formData.name.length < 2) {
        newErrors.name = 'Name must be at least 2 characters'
      }
    }

    if (!field || field === 'email') {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!formData.email) {
        newErrors.email = 'Email is required'
      } else if (!emailRegex.test(formData.email)) {
        newErrors.email = 'Invalid email format'
      }
    }

    if (!field || field === 'message') {
      if (!formData.message.trim()) {
        newErrors.message = 'Message is required'
      } else if (formData.message.length < 10) {
        newErrors.message = 'Message must be at least 10 characters'
      }
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleBlur = (field: keyof FormData) => {
    setTouched(prev => ({ ...prev, [field]: true }))
    validate(field)
  }

  const handleChange = (field: keyof FormData) => (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData(prev => ({ ...prev, [field]: e.target.value }))
    if (touched[field]) {
      validate(field)
    }
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()

    // Mark all fields as touched
    setTouched({ name: true, email: true, message: true })

    if (!validate()) {
      return
    }

    // Submit form
    console.log('Submitting:', formData)
  }

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <input
          name="name"
          value={formData.name}
          onChange={handleChange('name')}
          onBlur={() => handleBlur('name')}
        />
        {touched.name && errors.name && <span className="error">{errors.name}</span>}
      </div>

      <div>
        <input
          name="email"
          type="email"
          value={formData.email}
          onChange={handleChange('email')}
          onBlur={() => handleBlur('email')}
        />
        {touched.email && errors.email && <span className="error">{errors.email}</span>}
      </div>

      <div>
        <textarea
          name="message"
          value={formData.message}
          onChange={handleChange('message')}
          onBlur={() => handleBlur('message')}
        />
        {touched.message && errors.message && <span className="error">{errors.message}</span>}
      </div>

      <button type="submit">Submit</button>
    </form>
  )
}
```

### Schema Validation with Zod

```typescript
import { z } from 'zod'

const FormSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email format'),
  message: z.string().min(10, 'Message must be at least 10 characters')
})

type FormData = z.infer<typeof FormSchema>

export function ZodForm() {
  const [formData, setFormData] = useState<FormData>({
    name: '',
    email: '',
    message: ''
  })
  const [errors, setErrors] = useState<Record<string, string>>({})

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()

    try {
      const validated = FormSchema.parse(formData)
      console.log('Valid data:', validated)
    } catch (error) {
      if (error instanceof z.ZodError) {
        const formErrors: Record<string, string> = {}
        error.errors.forEach(err => {
          if (err.path[0]) {
            formErrors[err.path[0].toString()] = err.message
          }
        })
        setErrors(formErrors)
      }
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        value={formData.name}
        onChange={e => setFormData({ ...formData, name: e.target.value })}
      />
      {errors.name && <span className="error">{errors.name}</span>}
      {/* ... other fields */}
    </form>
  )
}
```

---

## Server Actions Pattern (Next.js 15)

### Basic Server Action Form

```typescript
'use server'

import { z } from 'zod'
import { revalidatePath } from 'next/cache'

const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000)
})

export async function createMarket(formData: FormData) {
  const session = await auth()
  if (!session) {
    return { error: 'Unauthorized' }
  }

  const validated = CreateMarketSchema.parse({
    name: formData.get('name'),
    description: formData.get('description')
  })

  const market = await db.markets.create({
    data: {
      ...validated,
      creatorId: session.user.id
    }
  })

  revalidatePath('/markets')
  return { success: true, market }
}
```

### Client Component Usage

```typescript
'use client'

export function CreateMarketForm() {
  const [state, formAction] = useFormState(createMarket, null)

  return (
    <form action={formAction}>
      <input name="name" required minLength={1} maxLength={200} />
      <textarea name="description" required minLength={1} maxLength={2000} />
      <button type="submit" disabled={state?.pending}>
        {state?.pending ? 'Creating...' : 'Create Market'}
      </button>
      {state?.error && <div className="error">{state.error}</div>}
    </form>
  )
}
```

### Server Action with Error Handling

```typescript
'use server'

export async function createMarket(prevState: any, formData: FormData) {
  try {
    const session = await auth()
    if (!session) {
      return { error: 'Unauthorized' }
    }

    const validated = CreateMarketSchema.parse({
      name: formData.get('name'),
      description: formData.get('description')
    })

    const market = await db.markets.create({
      data: { ...validated, creatorId: session.user.id }
    })

    revalidatePath('/markets')
    return { success: true, market }
  } catch (error) {
    if (error instanceof z.ZodError) {
      return { error: error.errors[0].message }
    }
    return { error: 'Failed to create market' }
  }
}
```

---

## Form Libraries

### React Hook Form Pattern

```typescript
'use client'

import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const FormSchema = z.object({
  name: z.string().min(2),
  email: z.string().email()
})

export function HookForm() {
  const {
    register,
    handleSubmit,
    formState: { errors }
  } = useForm({
    resolver: zodResolver(FormSchema)
  })

  const onSubmit = (data: z.infer<typeof FormSchema>) => {
    console.log(data)
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('name')} />
      {errors.name && <span>{errors.name.message}</span>}

      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}

      <button type="submit">Submit</button>
    </form>
  )
}
```

### Formik Pattern

```typescript
import { Formik, Form, Field, ErrorMessage } from 'formik'
import * as Yup from 'yup'

const ValidationSchema = Yup.object({
  name: Yup.string().min(2).required(),
  email: Yup.string().email().required()
})

export function FormikForm() {
  return (
    <Formik
      initialValues={{ name: '', email: '' }}
      validationSchema={ValidationSchema}
      onSubmit={(values) => {
        console.log(values)
      }}
    >
      {() => (
        <Form>
          <Field name="name" />
          <ErrorMessage name="name" component="span" />

          <Field name="email" type="email" />
          <ErrorMessage name="email" component="span" />

          <button type="submit">Submit</button>
        </Form>
      )}
    </Formik>
  )
}
```

---

## File Upload Patterns

### Basic File Upload

```typescript
export function FileUploadForm() {
  const [file, setFile] = useState<File | null>(null)
  const [uploading, setUploading] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!file) return

    setUploading(true)
    const formData = new FormData()
    formData.append('file', file)

    try {
      const response = await fetch('/api/upload', {
        method: 'POST',
        body: formData
      })
      const result = await response.json()
      console.log('Uploaded:', result)
    } catch (error) {
      console.error('Upload failed:', error)
    } finally {
      setUploading(false)
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="file"
        onChange={e => setFile(e.target.files?.[0] || null)}
      />
      <button type="submit" disabled={!file || uploading}>
        {uploading ? 'Uploading...' : 'Upload'}
      </button>
    </form>
  )
}
```

### With Progress Tracking

```typescript
export function FileUploadWithProgress() {
  const [file, setFile] = useState<File | null>(null)
  const [progress, setProgress] = useState(0)
  const [uploading, setUploading] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!file) return

    setUploading(true)
    setProgress(0)

    const xhr = new XMLHttpRequest()
    xhr.upload.addEventListener('progress', (e) => {
      if (e.lengthComputable) {
        setProgress(Math.round((e.loaded / e.total) * 100))
      }
    })

    xhr.addEventListener('load', () => {
      setUploading(false)
      console.log('Upload complete')
    })

    xhr.open('POST', '/api/upload')
    const formData = new FormData()
    formData.append('file', file)
    xhr.send(formData)
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="file"
        onChange={e => setFile(e.target.files?.[0] || null)}
      />
      {uploading && <progress value={progress} max={100} />}
      <button type="submit" disabled={!file || uploading}>
        Upload
      </button>
    </form>
  )
}
```

---

## Multi-Step Form Pattern

```typescript
type Step = 'personal' | 'address' | 'confirm'

export function MultiStepForm() {
  const [step, setStep] = useState<Step>('personal')
  const [data, setData] = useState({
    personal: { name: '', email: '' },
    address: { street: '', city: '', zip: '' }
  })

  const nextStep = () => {
    if (step === 'personal') setStep('address')
    else if (step === 'address') setStep('confirm')
  }

  const prevStep = () => {
    if (step === 'address') setStep('personal')
    else if (step === 'confirm') setStep('address')
  }

  return (
    <div>
      {step === 'personal' && (
        <PersonalStep
          data={data.personal}
          onChange={(personal) => setData({ ...data, personal })}
          onNext={nextStep}
        />
      )}
      {step === 'address' && (
        <AddressStep
          data={data.address}
          onChange={(address) => setData({ ...data, address })}
          onNext={nextStep}
          onPrev={prevStep}
        />
      )}
      {step === 'confirm' && (
        <ConfirmStep
          data={data}
          onPrev={prevStep}
          onSubmit={() => console.log('Submit:', data)}
        />
      )}
    </div>
  )
}
```

---

## Form Best Practices

### Accessibility

- Use proper `<label>` elements or `aria-label`
- Associate labels with inputs using `htmlFor` or `aria-describedby`
- Provide error messages linked to inputs via `aria-invalid` and `aria-describedby`
- Ensure keyboard navigation works
- Provide clear focus indicators

```typescript
<label htmlFor="email">Email</label>
<input
  id="email"
  type="email"
  aria-invalid={!!errors.email}
  aria-describedby={errors.email ? 'email-error' : undefined}
/>
{errors.email && (
  <span id="email-error" role="alert" className="error">
    {errors.email}
  </span>
)}
```

### UX Considerations

- Show validation errors inline, not alerts
- Provide clear error messages
- Disable submit button during submission
- Show loading state
- Preserve form data on error
- Clear form after successful submission
- Provide success feedback

```typescript
export function GoodForm() {
  const [status, setStatus] = useState<'idle' | 'loading' | 'success' | 'error'>('idle')
  const [error, setError] = useState<string | null>(null)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setStatus('loading')

    try {
      await submitForm(formData)
      setStatus('success')
      // Clear form or redirect
    } catch (err) {
      setError(err.message)
      setStatus('error')
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      {/* Form fields */}
      <button type="submit" disabled={status === 'loading'}>
        {status === 'loading' ? 'Submitting...' : 'Submit'}
      </button>
      {status === 'success' && <div className="success">Form submitted!</div>}
      {status === 'error' && <div className="error">{error}</div>}
    </form>
  )
}
```

---

## Form Anti-Patterns

### ❌ Uncontrolled Components for Complex Forms

```typescript
// BAD: No state management
<form>
  <input name="field1" />
  <input name="field2" />
  <button onClick={() => {
    const form = document.querySelector('form')
    const formData = new FormData(form)
    // Fragile, not type-safe
  }}>Submit</button>
</form>

// GOOD: Controlled components
<form onSubmit={handleSubmit}>
  <input value={field1} onChange={e => setField1(e.target.value)} />
  <input value={field2} onChange={e => setField2(e.target.value)} />
  <button type="submit">Submit</button>
</form>
```

### ❌ onSubmit on Button Instead of Form

```typescript
// BAD: Button onClick
<button onClick={handleSubmit}>Submit</button>

// GOOD: Form onSubmit
<form onSubmit={handleSubmit}>
  <button type="submit">Submit</button>
</form>
```

### ❌ Alert for Validation

```typescript
// BAD: Using alert
if (error) alert('Invalid input')

// GOOD: Inline error
{error && <div className="error">{error}</div>}
```
