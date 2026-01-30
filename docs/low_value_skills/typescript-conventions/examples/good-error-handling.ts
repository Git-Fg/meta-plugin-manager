// GOOD: Typed error classes with context
class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field?: string,
    public readonly context?: Record<string, unknown>,
  ) {
    super(message);
    this.name = "ValidationError";
  }
}

class NotFoundError extends Error {
  constructor(resource: string, id: string) {
    super(`${resource} with id '${id}' not found`);
    this.name = "NotFoundError";
  }
}

class DatabaseError extends Error {
  constructor(
    message: string,
    public readonly query?: string,
    public readonly cause?: Error,
  ) {
    super(message);
    this.name = "DatabaseError";
  }
}

// GOOD: Result<T> pattern for operations that can fail
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

function validateUser(
  user: unknown,
): Result<UserValidationResult, ValidationError> {
  try {
    // validation logic
    return { success: true, data: result };
  } catch (error) {
    return {
      success: false,
      error: new ValidationError("Validation failed", "user", {
        error: error instanceof Error ? error.message : "Unknown error",
      }),
    };
  }
}

// GOOD: Explicit return types
function parseEmail(input: string): Result<Email, ValidationError> {
  if (!input.includes("@")) {
    return {
      success: false,
      error: new ValidationError("Invalid email format", "email", { input }),
    };
  }
  return { success: true, data: input as Email };
}
