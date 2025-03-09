/*
  # Fix orders foreign key constraint

  1. Changes
    - Drop existing foreign key constraint
    - Create new users table with default guest user
    - Re-create foreign key constraint
    - Add guest user record

  2. Notes
    - Creates a special guest user record
    - Maintains referential integrity while allowing guest orders
*/

-- First, drop the existing foreign key constraint
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_user_id_fkey;

-- Create users table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY,
  email text UNIQUE,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS on users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Insert the guest user if it doesn't exist
INSERT INTO users (id, email)
VALUES ('00000000-0000-0000-0000-000000000000', 'guest@example.com')
ON CONFLICT (id) DO NOTHING;

-- Re-create the foreign key constraint
ALTER TABLE orders
ADD CONSTRAINT orders_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES users(id);