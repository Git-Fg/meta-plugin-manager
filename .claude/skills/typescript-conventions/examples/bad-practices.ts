// BAD: Using 'any' type
function processData(data: any): any {
  return data;
}

// BAD: Default exports
export default function process() {}

// BAD: Bare Error throwing
function validateInput(input: unknown) {
  if (!input) {
    throw new Error("Invalid input");
  }
}

// BAD: Direct mutation
function updateUser(user: User) {
  user.name = "New Name"; // Mutates original object
}

// BAD: Console.log in production
function fetchData() {
  console.log("Fetching data..."); // Should use proper logging
  return fetch("/api/data");
}

// BAD: Magic numbers
function retryRequest() {
  if (retryCount > 3 && elapsed > 5000) {
    // What do 3 and 5000 mean?
  }
}

// BAD: Mixed concerns in single file
// This file contains UI, business logic, and data access
class UserComponent {
  render() {
    /* UI */
  }
  validate() {
    /* Business */
  }
  saveToDb() {
    /* Data access */
  }
}
