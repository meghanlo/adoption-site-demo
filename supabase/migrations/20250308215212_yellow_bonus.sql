/*
  # Clear users and orders tables safely

  1. Changes
    - Delete all orders first to handle foreign key constraints
    - Ensure guest user exists
    - Clear users table while preserving guest user
    - Maintain all RLS policies

  2. Security
    - Maintains RLS policies
    - Preserves table structure and constraints
    - Ensures guest user functionality remains intact
*/

-- First delete all orders to handle foreign key constraints
DELETE FROM orders;

-- Ensure the guest user exists
INSERT INTO users (id, email)
VALUES ('00000000-0000-0000-0000-000000000000', 'guest@example.com')
ON CONFLICT (id) DO NOTHING;

-- Delete all users except the guest user
DELETE FROM users
WHERE id != '00000000-0000-0000-0000-000000000000';

-- Ensure RLS is enabled
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can read user data" ON users;
DROP POLICY IF EXISTS "Users can insert their own data" ON users;
DROP POLICY IF EXISTS "Users can manage their own data" ON users;

-- Recreate the RLS policies
CREATE POLICY "Public can read user data"
  ON users
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can insert their own data"
  ON users
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can manage their own data"
  ON users
  FOR ALL
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);