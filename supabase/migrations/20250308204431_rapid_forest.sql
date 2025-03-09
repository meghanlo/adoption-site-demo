/*
  # Update dog listings content

  1. Changes
    - Updates each product with unique dog names, descriptions, and GIFs
    - Maintains existing product IDs and relationships
    - Each dog has a personality-matched GIF and description
*/

-- Update existing products one by one to avoid window functions
UPDATE products 
SET 
  name = 'Cooper the Golden Retriever',
  description = 'A playful 2-year-old golden boy who lives for tennis balls and belly rubs. Cooper has never met a stranger and would make the perfect family companion!',
  image_url = 'https://media.giphy.com/media/3oKIPc9VZj4ylzjcys/giphy.gif'
WHERE id = (SELECT id FROM products ORDER BY created_at ASC LIMIT 1);

UPDATE products 
SET 
  name = 'Shadow the Husky',
  description = 'Meet Shadow, a dramatic 1-year-old husky who thinks he''s an opera singer. Full of energy and sass, he''s looking for an active family who appreciates his "singing"!',
  image_url = 'https://media.giphy.com/media/9Jcw5pUQlgQLe5NonJ/giphy.gif'
WHERE id = (SELECT id FROM products ORDER BY created_at ASC OFFSET 1 LIMIT 1);

UPDATE products 
SET 
  name = 'Ziggy the Corgi',
  description = 'This 3-year-old bundle of joy has the cutest waddle you''ve ever seen! Ziggy loves herding anything that moves and is an expert at stealing hearts.',
  image_url = 'https://media.giphy.com/media/Y4pAQv58ETJgRwoLxj/giphy.gif'
WHERE id = (SELECT id FROM products ORDER BY created_at ASC OFFSET 2 LIMIT 1);

UPDATE products 
SET 
  name = 'Duke the Labrador',
  description = 'A gentle giant with a heart of gold, 4-year-old Duke is already trained and loves swimming. He''s great with kids and makes the perfect family companion!',
  image_url = 'https://media.giphy.com/media/l3q2HWkLF9sy9Jg1q/giphy.gif'
WHERE id = (SELECT id FROM products ORDER BY created_at ASC OFFSET 3 LIMIT 1);

UPDATE products 
SET 
  name = 'Rex the German Shepherd',
  description = 'Meet Rex, a noble 2-year-old shepherd with intelligence that will amaze you. He excels at training and would make an excellent companion for an experienced dog owner.',
  image_url = 'https://media.giphy.com/media/mCRJDo24UvJMA/giphy.gif'
WHERE id = (SELECT id FROM products ORDER BY created_at ASC OFFSET 4 LIMIT 1);

UPDATE products 
SET 
  name = 'Milo the Pug',
  description = 'This adorable 1-year-old pug is a certified couch potato champion! Milo loves short walks, long naps, and being the center of attention in his forever home.',
  image_url = 'https://media.giphy.com/media/12uXi1GXBibALC/giphy.gif'
WHERE id = (SELECT id FROM products ORDER BY created_at ASC OFFSET 5 LIMIT 1);