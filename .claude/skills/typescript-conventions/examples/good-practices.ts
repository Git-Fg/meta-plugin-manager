// GOOD: Immutability with spread operator
const updatedUser = { ...user, name: "New Name" };
const updatedArray = [...items, newItem];
const updatedMap = new Map(originalMap).set(key, value);

// GOOD: Early returns instead of deep nesting
function processUser(
  user: User | null,
): Result<ProcessedUser, ValidationError> {
  if (!user) {
    return { success: false, error: new ValidationError("User required") };
  }

  if (!isValidEmail(user.email)) {
    return {
      success: false,
      error: new ValidationError("Invalid email", "email"),
    };
  }

  if (!user.isActive) {
    return { success: false, error: new ValidationError("User inactive") };
  }

  return { success: true, data: process(user) };
}

// GOOD: Constants instead of magic numbers
const MIN_AGE = 18;
const MAX_AGE = 120;
const MIN_NAME_LENGTH = 2;
const MAX_NAME_LENGTH = 100;

function validateAge(age: number): Result<void, ValidationError> {
  if (age < MIN_AGE || age > MAX_AGE) {
    return {
      success: false,
      error: new ValidationError(
        `Age must be between ${MIN_AGE} and ${MAX_AGE}`,
        "age",
        { age },
      ),
    };
  }
  return { success: true, data: undefined };
}

// GOOD: Named exports, single responsibility
export interface UserRepository {
  findById(id: UserId): Promise<Result<User, NotFoundError>>;
}

export class DatabaseUserRepository implements UserRepository {
  async findById(id: UserId): Promise<Result<User, NotFoundError>> {
    // implementation
  }
}
