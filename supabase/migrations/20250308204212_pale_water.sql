/*
  # Update dog GIFs

  1. Changes
    - Updates each product with a unique, dog-specific GIF
    - Maintains existing product data while only updating image URLs
*/

-- Update existing products with new GIFs
UPDATE products
SET image_url = CASE id
  WHEN (SELECT id FROM products ORDER BY created_at ASC LIMIT 1)
    THEN 'https://media.giphy.com/media/4Zo41lhzKt6iZ8xff9/giphy.gif' -- Labrador playing
  WHEN (SELECT id FROM products ORDER BY created_at ASC OFFSET 1 LIMIT 1)
    THEN 'https://media.giphy.com/media/3o7TKSha51ATTx9KzC/giphy.gif' -- Golden retriever running
  WHEN (SELECT id FROM products ORDER BY created_at ASC OFFSET 2 LIMIT 1)
    THEN 'https://media.giphy.com/media/51Uiuy5QBZNkoF3b2Z/giphy.gif' -- Husky being silly
  WHEN (SELECT id FROM products ORDER BY created_at ASC OFFSET 3 LIMIT 1)
    THEN 'https://media.giphy.com/media/1d5U0OaCqfC0DQpriC/giphy.gif' -- Corgi bouncing
  WHEN (SELECT id FROM products ORDER BY created_at ASC OFFSET 4 LIMIT 1)
    THEN 'https://media.giphy.com/media/12PA1eI8FBqEBa/giphy.gif' -- Pug being cute
  WHEN (SELECT id FROM products ORDER BY created_at ASC OFFSET 5 LIMIT 1)
    THEN 'https://media.giphy.com/media/B2vBunhgt9Pc4/giphy.gif' -- German Shepherd playing
  ELSE image_url
END;