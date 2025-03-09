/*
  # Add RLS policies for orders and order items

  1. Security Changes
    - Enable RLS on orders and order_items tables
    - Add policies for:
      - Creating orders (both authenticated and guest users)
      - Reading orders (users can only read their own orders)
      - Creating order items (linked to order creation)
      - Reading order items (users can only read items from their orders)

  2. Notes
    - Guest orders use a special UUID: 00000000-0000-0000-0000-000000000000
    - Authenticated users can only access their own orders
    - Order items are protected through their relationship with orders
*/

-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Orders policies
CREATE POLICY "Enable read access for users own orders"
ON orders FOR SELECT
USING (
  auth.uid() = user_id OR 
  (user_id = '00000000-0000-0000-0000-000000000000' AND is_guest = true)
);

CREATE POLICY "Enable insert access for orders"
ON orders FOR INSERT
WITH CHECK (
  auth.uid() = user_id OR 
  (user_id = '00000000-0000-0000-0000-000000000000' AND is_guest = true)
);

-- Order items policies
CREATE POLICY "Enable read access for users own order items"
ON order_items FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM orders
    WHERE orders.id = order_items.order_id
    AND (orders.user_id = auth.uid() OR (orders.user_id = '00000000-0000-0000-0000-000000000000' AND orders.is_guest = true))
  )
);

CREATE POLICY "Enable insert access for order items"
ON order_items FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM orders
    WHERE orders.id = order_items.order_id
    AND (orders.user_id = auth.uid() OR (orders.user_id = '00000000-0000-0000-0000-000000000000' AND orders.is_guest = true))
  )
);