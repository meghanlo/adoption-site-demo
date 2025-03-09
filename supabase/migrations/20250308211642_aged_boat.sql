/*
  # Copy existing products data

  This migration ensures the products table exists with the current data and security policies.

  1. Schema
    - Creates the products table if it doesn't exist
    - Columns:
      - id (uuid): Primary key with default random UUID
      - name (text): Product name, not null
      - description (text): Optional product description
      - price (integer): Price in cents, not null
      - image_url (text): Optional URL to product image
      - created_at (timestamptz): Timestamp with timezone, defaults to now()

  2. Security
    - Enables Row Level Security (RLS)
    - Adds policy for public read access if it doesn't exist

  3. Data
    - Inserts the current product data
    - Uses ON CONFLICT to safely handle existing records
*/

-- Create the products table if it doesn't exist
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

-- Create policy if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'products' 
        AND policyname = 'Anyone can view products'
    ) THEN
        CREATE POLICY "Anyone can view products"
            ON products
            FOR SELECT
            TO public
            USING (true);
    END IF;
END $$;

-- Insert the current data
INSERT INTO products (id, name, description, price, image_url)
VALUES
    ('67c9fa1c-1d46-4701-a5c7-df4c85539bef', 'Charlie the Corgi', 'A cheerful and outgoing 2-year-old with a big personality in a small package! He loves zooming around the yard, learning new tricks, and getting belly rubs. Fantastic with kids and other pets!', 249900, 'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMXNlYmVlbDBldHFwMjJyNG52ZnY1N21xNHkzamh0c2M1NnZ3bzcwciZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/A6XISxDsthHGw/giphy.gif'),
    ('89b9d5e4-3a2f-4b1c-9c8d-7a6e5b4f3d2e', 'Milo the Pug', 'This adorable 1-year-old pug is a certified couch potato champion! Milo loves short walks, long naps, and being the center of attention in his forever home.', 299900, 'https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHZ3eW1rbDQ0YjhwbnIwN2RiNjgxZHlxMnRmb3Y5bzZmdmo1YjU1dyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/b2WCqBlDMAaUTHWzxc/giphy.gif'),
    ('12e3f4a5-b6c7-8d9e-0f1a-2b3c4d5e6f7a', 'Cooper the Golden Retriever', 'A playful 2-year-old golden boy who lives for tennis balls and belly rubs. Cooper has never met a stranger and would make the perfect family companion!', 279900, 'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMzZsdTF0eng3aXNreTJscTc0azllNm4ybmwzZHMybTVraWtnMml4diZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/BLCHvwl9C5j1u/giphy.gif'),
    ('34f5e6d7-c8b9-4a1b-2c3d-4e5f67890123', 'Max the Golden Retriever', 'A friendly and energetic 2-year-old who loves to play fetch and swim. Great with kids and other pets!', 199900, 'https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExZXdqbTl5M3JreTQ5dXJwN2F2ams4dzc2b2VmYnFscjU0bHA4cmpkciZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/4PZC0622p78vD0OZSs/giphy.gif'),
    ('56781234-5678-4abc-8def-567812345678', 'Shadow the Husky', 'Meet Shadow, a dramatic 1-year-old husky. Full of energy and sass and looking for an active family who appreciates his "singing"!', 259900, 'https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExcjA2a2drZnJ4aGRncmw5cmRrc2FjNTI5Z3VxOGlncjV4cGhnc2kybiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/lk9MPPlFZfETm/giphy.gif'),
    ('78901234-abcd-4ef5-89ab-123456789012', 'Kobe the Shiba Inu', 'A confident and spirited 3-year-old with a foxy face and a fluffy tail! He loves adventure, playing tug-of-war, and basking in the sun. Loyal, independent, and great with active families!', 229900, 'https://media.giphy.com/media/B2vBunhgt9Pc4/giphy.gif')
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    image_url = EXCLUDED.image_url;