/*
  # Create products table with current data

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
INSERT INTO products (name, description, price, image_url) VALUES
  ('Bailey', 'A lovable Golden Retriever who brings sunshine wherever she goes', 129900, 'https://media.giphy.com/media/51Uiuy5QBZNkoF3b2Z/giphy.gif'),
  ('Shadow', 'A majestic German Shepherd with a heart of gold', 149900, 'https://media.giphy.com/media/51Uiuy5QBZNkoF3b2Z/giphy-downsized-large.gif'),
  ('Ziggy', 'An energetic Border Collie who loves to learn new tricks', 119900, 'https://media.giphy.com/media/51Uiuy5QBZNkoF3b2Z/giphy.gif'),
  ('Milo', 'A cheerful Beagle with an adventurous spirit', 99900, 'https://media.giphy.com/media/51Uiuy5QBZNkoF3b2Z/giphy-downsized-large.gif'),
  ('Ruby', 'A gentle Bernese Mountain Dog who loves winter walks', 169900, 'https://media.giphy.com/media/51Uiuy5QBZNkoF3b2Z/giphy.gif'),
  ('Leo', 'A playful Siberian Husky with striking blue eyes', 139900, 'https://media.giphy.com/media/51Uiuy5QBZNkoF3b2Z/giphy-downsized-large.gif')
ON CONFLICT (id) DO NOTHING;