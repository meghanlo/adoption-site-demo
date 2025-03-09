/*
  # Create products table with initial data

  1. New Tables
    - `products`
      - `id` (uuid, primary key)
      - `name` (text, not null)
      - `description` (text)
      - `price` (integer, not null)
      - `image_url` (text)
      - `created_at` (timestamptz, default: now())

  2. Security
    - Enable RLS on `products` table
    - Add policy for public read access to products

  3. Initial Data
    - Insert current dog data from Supabase
*/

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  price integer NOT NULL,
  image_url text,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Anyone can view products"
  ON products
  FOR SELECT
  TO public
  USING (true);

-- Insert initial data
INSERT INTO products (id, name, description, price, image_url) VALUES
  ('d0d116e5-0738-4604-8328-d8e0ec7e4d73', 'Luna', 'A playful and energetic Husky mix with striking blue eyes', 149900, 'https://images.unsplash.com/photo-1605568427561-40dd23c2acea?w=800&auto=format&fit=crop'),
  ('7c5c7e8f-4b5a-4c0e-9b1a-1d2e3f4a5b6c', 'Max', 'A gentle German Shepherd who loves children and long walks', 169900, 'https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?w=800&auto=format&fit=crop'),
  ('9e8d7c6b-5a4b-3c2e-1d0f-9e8d7c6b5a4b', 'Bella', 'A sweet Golden Retriever with a heart of gold', 159900, 'https://images.unsplash.com/photo-1633722715463-d30f4f325e24?w=800&auto=format&fit=crop'),
  ('2b3c4d5e-6f7g-8h9i-j0k1-l2m3n4o5p6q', 'Rocky', 'An athletic Boxer who excels at agility training', 139900, 'https://images.unsplash.com/photo-1598133894008-61f7fdb8cc3a?w=800&auto=format&fit=crop'),
  ('f1e2d3c4-b5a6-7890-cdef-ghij1234klmn', 'Daisy', 'A cuddly Labrador Retriever who loves water activities', 179900, 'https://images.unsplash.com/photo-1591160690555-5debfba289f0?w=800&auto=format&fit=crop'),
  ('a9b8c7d6-e5f4-3210-fedc-ba9876543210', 'Charlie', 'A smart Border Collie who picks up tricks quickly', 169900, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800&auto=format&fit=crop')
ON CONFLICT (id) DO NOTHING;