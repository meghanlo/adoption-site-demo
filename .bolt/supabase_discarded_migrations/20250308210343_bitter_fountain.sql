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
    - Insert sample dog data with unique names, descriptions, and GIFs
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
  ('Luna', 'A playful Husky with boundless energy and a heart of gold', 9999, 'https://media.giphy.com/media/4Zo41lhzKt6iZ8xff9/giphy.gif'),
  ('Max', 'A gentle German Shepherd who loves cuddles and long walks', 8999, 'https://media.giphy.com/media/3o7TKPdUkkbCAVqWk0/giphy.gif'),
  ('Bella', 'An adorable Golden Retriever puppy with a sunny disposition', 12999, 'https://media.giphy.com/media/4T7e4DmcrP9du/giphy.gif'),
  ('Charlie', 'A smart Border Collie who picks up tricks in no time', 10999, 'https://media.giphy.com/media/Y4pAQv58ETJgRwoLxj/giphy.gif'),
  ('Daisy', 'A sweet Labrador who adores swimming and playing fetch', 11999, 'https://media.giphy.com/media/3o7TKPJPkhHa9AcLkc/giphy.gif'),
  ('Rocky', 'A brave Rottweiler with a protective nature and loving heart', 9499, 'https://media.giphy.com/media/Y4pAQv58ETJgRwoLxj/giphy.gif'),
  ('Lucy', 'A charming Beagle who follows her nose to adventure', 8499, 'https://media.giphy.com/media/3o7TKPdUkkbCAVqWk0/giphy.gif'),
  ('Cooper', 'An energetic Australian Shepherd who loves agility training', 11499, 'https://media.giphy.com/media/4T7e4DmcrP9du/giphy.gif'),
  ('Molly', 'A friendly Pug who brings smiles wherever she goes', 7999, 'https://media.giphy.com/media/3o7TKSha51ATTx9KzC/giphy.gif')
ON CONFLICT (id) DO NOTHING;