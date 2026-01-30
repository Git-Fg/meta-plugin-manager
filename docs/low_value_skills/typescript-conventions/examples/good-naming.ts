// GOOD: Interfaces follow naming conventions and use descriptive names
interface UserRepository {
  findById(id: UserId): Promise<Result<User, NotFoundError>>;
  save(user: User): Promise<Result<void, DatabaseError>>;
}

interface MarketData {
  id: string;
  name: string;
  status: "active" | "resolved" | "closed";
}

// GOOD: Type aliases for primitives with semantic meaning
type UserId = string & { readonly brand: unique symbol };
type Email = string & { readonly brand: unique symbol };

// GOOD: Enums use PascalCase
enum UserRole {
  ADMIN = "admin",
  EDITOR = "editor",
  VIEWER = "viewer",
}

enum HttpStatus {
  OK = 200,
  CREATED = 201,
  NOT_FOUND = 404,
  INTERNAL_ERROR = 500,
}

// GOOD: Constants use UPPER_SNAKE_CASE
const MAX_RETRIES = 3;
const DEFAULT_TIMEOUT_MS = 5000;
const MIN_NAME_LENGTH = 2;

// GOOD: Variables and functions use camelCase
function getUserById(id: UserId): Promise<Result<User, NotFoundError>> {
  // implementation
}

const userData: Map<string, User> = new Map();
const isValidEmail = (email: string): boolean => email.includes("@");
