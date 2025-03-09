/*
  # Update products with dog listings

  1. Changes
    - Updates existing products table with dog adoption listings
    - Preserves referential integrity by updating existing records
    - Each listing includes:
      - Name of the dog
      - Description of personality and characteristics
      - Adoption fee
      - GIF image URL
*/

-- Create a temporary table to store the new data
CREATE TEMPORARY TABLE temp_products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price INTEGER NOT NULL,
  image_url TEXT
);

-- Insert the new data into the temporary table
INSERT INTO temp_products (name, description, price, image_url) VALUES
  ('Max the Golden Retriever', 'A friendly and energetic 2-year-old who loves to play fetch and swim. Great with kids and other pets!', 25000, 'https://media.giphy.com/media/3o7TKSha51ATTx9KzC/giphy.gif'),
  ('Luna the Husky', 'A beautiful 1-year-old with striking blue eyes. Very vocal and loves to "talk". Perfect for active families!', 30000, 'https://media.giphy.com/media/51Uiuy5QBZNkoF3b2Z/giphy.gif'),
  ('Charlie the Corgi', 'An adorable 3-year-old with a big personality in a small package. Expert at belly rubs and making people smile!', 28000, 'https://media.giphy.com/media/1d5U0OaCqfC0DQpriC/giphy.gif'),
  ('Bella the Labrador', 'A gentle 4-year-old black lab who loves cuddles and treats. Already trained and great with commands!', 22000, 'https://media.giphy.com/media/4Zo41lhzKt6iZ8xff9/giphy.gif'),
  ('Rocky the German Shepherd', 'A smart and loyal 2-year-old who picks up training quickly. Makes an excellent companion and guardian!', 32000, 'https://media.giphy.com/media/B2vBunhgt9Pc4/giphy.gif'),
  ('Daisy the Pug', 'A charming 1-year-old pug with a heart of gold. Perfect apartment companion who loves short walks and long naps!', 27000, 'https://media.giphy.com/media/12PA1eI8FBqEBa/giphy.gif');

-- Update existing products
UPDATE products p
SET 
  name = t.name,
  description = t.description,
  price = t.price,
  image_url = t.image_url
FROM (
  SELECT 
    p.id as product_id,
    t.name,
    t.description,
    t.price,
    t.image_url
  FROM products p
  JOIN temp_products t ON t.id <= (SELECT COUNT(*) FROM products)
) t
WHERE p.id = t.product_id;

-- Insert new products if we have less than 6
INSERT INTO products (name, description, price, image_url)
SELECT 
  t.name,
  t.description,
  t.price,
  t.image_url
FROM temp_products t
WHERE t.id > (SELECT COUNT(*) FROM products);