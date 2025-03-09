/*
  # Populate products with French pastries

  1. Data Population
    - Add a curated selection of French pastries to the products table
    - Each product includes:
      - name
      - description
      - price (in cents)
      - image_url (from Unsplash)
*/

INSERT INTO products (name, description, price, image_url) VALUES
  (
    'Croissant',
    'Classic French butter croissant with a flaky, layered texture and golden-brown exterior',
    395,
    'https://images.unsplash.com/photo-1555507036-ab1f4038808a'
  ),
  (
    'Pain au Chocolat',
    'Buttery pastry filled with rich dark chocolate batons',
    425,
    'https://images.unsplash.com/photo-1608198093002-ad4e005484ec'
  ),
  (
    'Éclair au Chocolat',
    'Choux pastry filled with chocolate cream and topped with chocolate ganache',
    495,
    'https://images.unsplash.com/photo-1528975604071-b4dc52a2d18c'
  ),
  (
    'Macaron',
    'Delicate almond meringue cookies with various flavored fillings',
    350,
    'https://images.unsplash.com/photo-1569864358642-9d1684040f43'
  ),
  (
    'Mille-feuille',
    'Layers of puff pastry with vanilla cream and powdered sugar',
    595,
    'https://images.unsplash.com/photo-1482275548304-a58859dc31b7'
  ),
  (
    'Tarte aux Fruits',
    'Buttery pastry crust filled with vanilla cream and topped with fresh seasonal fruits',
    695,
    'https://images.unsplash.com/photo-1488477181946-6428a0291777'
  ),
  (
    'Choux à la Crème',
    'Light and airy cream puff filled with vanilla pastry cream',
    445,
    'https://images.unsplash.com/photo-1621303837174-89787a7d4729'
  ),
  (
    'Paris-Brest',
    'Ring-shaped choux pastry filled with praline cream',
    595,
    'https://images.unsplash.com/photo-1550617931-e17a7b70dce2'
  ),
  (
    'Tarte au Citron',
    'Classic French lemon tart with smooth citrus curd in a buttery crust',
    545,
    'https://images.unsplash.com/photo-1494124013959-a5d75d2a3654'
  ),
  (
    'Religieuse',
    'Two choux buns filled with pastry cream and decorated with ganache',
    525,
    'https://images.unsplash.com/photo-1551404973-761c83cd8339'
  );