// BEFORE: Function does multiple things - validation, calculation, persistence
function process(o: any) {
  // Validation
  if (!o.id || !o.items || o.items.length === 0) {
    return null;
  }

  // Calculate total
  let total = 0;
  for (const i of o.items) {
    total += i.qty * i.p;
  }

  // Apply discount
  if (o.coupon) {
    total *= 0.9;
  }

  // Save
  db.save({ ...o, total });

  return total;
}

// AFTER: Each function has single responsibility
interface Order {
  id: string;
  items: OrderItem[];
  couponCode?: string;
}

interface OrderItem {
  productId: string;
  quantity: number;
  price: number;
}

function processOrder(order: Order): number | null {
  if (!isValidOrder(order)) return null;

  const total = calculateOrderTotal(order.items);
  const discountedTotal = applyCouponDiscount(total, order.couponCode);

  saveOrder({ ...order, total: discountedTotal });

  return discountedTotal;
}

function isValidOrder(order: Order): boolean {
  return !!(order.id && order.items?.length > 0);
}

function calculateOrderTotal(items: OrderItem[]): number {
  return items.reduce((sum, item) => sum + item.quantity * item.price, 0);
}

function applyCouponDiscount(total: number, couponCode?: string): number {
  if (couponCode === "SAVE10") {
    return total * 0.9;
  }
  return total;
}

function saveOrder(order: Order): void {
  database.orders.save(order);
}
