/*
  # Add RLS policies for users table

  1. Security Changes
    - Enable RLS on users table
    - Add policy for users to manage their own data
    - Add policy for authenticated users to insert their own data
    - Add policy for public to read user data (needed for order relationships)
*/

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Allow users to manage their own data
CREATE POLICY "Users can manage their own data"
  ON users
  FOR ALL
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow users to insert their own data during signup/signin
CREATE POLICY "Users can insert their own data"
  ON users
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Allow public read access (needed for order relationships)
CREATE POLICY "Public can read user data"
  ON users
  FOR SELECT
  TO public
  USING (true);