// BEFORE: Duplicated date formatting logic across codebase
// In file1.ts:
const f1 = `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}`;

// In file2.ts:
const formatted = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;

// In file3.ts:
const dStr = `${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()}`;

// AFTER: Single source of truth in utils/date.ts
export function formatDateISO(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");

  return `${year}-${month}-${day}`;
}

// Consistent usage across codebase
import { formatDateISO } from "./utils/date";

const formatted = formatDateISO(new Date());
const displayDate = formatDateISO(user.createdAt);
const expiryDate = formatDateISO(order.expiresAt);
