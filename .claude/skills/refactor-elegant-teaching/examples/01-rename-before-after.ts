// BEFORE: Obscure naming requires comments to understand
function p(o: any): any {
  if (o && o.a && o.a.b) {
    const t = o.a.b.c || [];
    return t.filter((x: any) => x.d).map((x: any) => x.e);
  }
  return [];
}

// AFTER: Clear naming makes code self-documenting
interface Order {
  items: OrderItem[];
  status: "pending" | "processing" | "shipped";
}

interface OrderItem {
  productId: string;
  quantity: number;
  price: number;
}

function getActiveOrderItems(order: Order | null): OrderItem[] {
  if (!order) return [];

  const validItems = order.items.filter((item) => item.quantity > 0);
  return validItems;
}
