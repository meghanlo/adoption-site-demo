/*
  # Remove duplicate products safely

  This migration removes duplicate products while preserving referential integrity:
  1. Identifies duplicates by name
  2. Updates order_items to reference the primary product entry
  3. Removes duplicate products safely

  1. Changes
    - Updates order_items to reference the primary product for each name
    - Removes duplicate products while maintaining data integrity
    - Preserves all order history
*/

BEGIN;

-- Update order_items to reference the primary product
WITH primary_products AS (
  SELECT DISTINCT ON (name) 
    id as primary_id,
    name
  FROM products
  ORDER BY name, created_at ASC
),
duplicates AS (
  SELECT 
    p.id as duplicate_id,
    pp.primary_id
  FROM products p
  JOIN primary_products pp ON p.name = pp.name
  WHERE p.id != pp.primary_id
)
UPDATE order_items
SET product_id = d.primary_id
FROM duplicates d
WHERE order_items.product_id = d.duplicate_id;

-- Now safely delete the duplicates
DELETE FROM products
WHERE id IN (
  SELECT p.id
  FROM products p
  WHERE EXISTS (
    SELECT 1
    FROM products p2
    WHERE p2.name = p.name
    AND p2.created_at < p.created_at
  )
);

COMMIT;