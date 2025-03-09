/*
  # Add is_guest column to orders table

  1. Changes
    - Add `is_guest` boolean column to `orders` table with default value of false
    - This column helps identify orders placed by guest users

  2. Security
    - Maintain existing RLS policies
*/

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'orders' AND column_name = 'is_guest'
  ) THEN
    ALTER TABLE orders ADD COLUMN is_guest boolean DEFAULT false;
  END IF;
END $$;