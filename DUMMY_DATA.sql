-- ============================================
-- ShopEase Dummy Data
-- 5 Categories, 10 Products, 20 Invoices
-- ============================================

-- Clear existing data (optional - remove if you want to keep existing data)
-- DELETE FROM invoice_items;
-- DELETE FROM invoices;
-- DELETE FROM stock_transactions;
-- DELETE FROM products;
-- DELETE FROM categories;

-- ============================================
-- 1. GET USER ID & INSERT CATEGORIES (5)
-- ============================================

DO $$
DECLARE
  user_id UUID;
BEGIN
  -- Get first user ID (or use your specific user ID)
  SELECT id INTO user_id FROM profiles LIMIT 1;

  -- Insert categories with user_id
  INSERT INTO categories (name, description, icon, color, created_by, created_at, updated_at)
  VALUES
    ('Electronics', 'Electronic devices and gadgets', 'Laptop', '#3b82f6', user_id, NOW(), NOW()),
    ('Clothing', 'Fashion and apparel items', 'Shirt', '#ec4899', user_id, NOW(), NOW()),
    ('Home & Kitchen', 'Home appliances and kitchenware', 'Home', '#10b981', user_id, NOW(), NOW()),
    ('Sports', 'Sports equipment and accessories', 'Dumbbell', '#f59e0b', user_id, NOW(), NOW()),
    ('Books', 'Books and educational materials', 'Book', '#8b5cf6', user_id, NOW(), NOW())
  ON CONFLICT (name) DO NOTHING;
END $$;

-- ============================================
-- 2. INSERT PRODUCTS (10)
-- ============================================

DO $$
DECLARE
  user_id UUID;
BEGIN
  -- Get first user ID
  SELECT id INTO user_id FROM profiles LIMIT 1;

  -- Insert products with user_id
  INSERT INTO products (name, sku, category, price, cost_price, quantity, low_stock_threshold, created_by, created_at, updated_at)
  VALUES
    -- Electronics (3 products)
    ('iPhone 15 Pro', 'IPH-15-PRO-001', 'Electronics', 1199.99, 899.99, 8, 10, user_id, NOW(), NOW()),
    ('Samsung Galaxy S24', 'SAM-S24-002', 'Electronics', 999.99, 749.99, 7, 10, user_id, NOW(), NOW()),
    ('MacBook Pro 16"', 'MBP-16-003', 'Electronics', 2499.99, 1899.99, 15, 5, user_id, NOW(), NOW()),

    -- Clothing (2 products)
    ('Classic T-Shirt', 'TSH-CLR-004', 'Clothing', 24.99, 9.99, 150, 20, user_id, NOW(), NOW()),
    ('Denim Jeans', 'DNM-JNS-005', 'Clothing', 59.99, 29.99, 45, 15, user_id, NOW(), NOW()),

    -- Home & Kitchen (2 products)
    ('Coffee Maker', 'COF-MKR-006', 'Home & Kitchen', 89.99, 45.99, 25, 10, user_id, NOW(), NOW()),
    ('Air Fryer', 'AIR-FRY-007', 'Home & Kitchen', 129.99, 69.99, 18, 8, user_id, NOW(), NOW()),

    -- Sports (2 products)
    ('Yoga Mat', 'YGA-MAT-008', 'Sports', 39.99, 15.99, 60, 15, user_id, NOW(), NOW()),
    ('Dumbbells Set', 'DMB-SET-009', 'Sports', 149.99, 79.99, 12, 10, user_id, NOW(), NOW()),

    -- Books (1 product)
    ('Programming Guide', 'PRG-GDE-010', 'Books', 49.99, 24.99, 35, 10, user_id, NOW(), NOW())
  ON CONFLICT (sku) DO NOTHING;
END $$;

-- ============================================
-- 3. INSERT INVOICES (20)
-- ============================================

-- Note: Replace 'user-uuid-here' with an actual user ID from your profiles table
-- You can get a user ID by running: SELECT id FROM profiles LIMIT 1;

-- For this example, we'll use a placeholder. You should replace it with your actual user ID.
-- Get your user ID first, then replace 'YOUR_USER_ID_HERE' in all invoices below.

DO $$
DECLARE
  product_iphone UUID;
  product_samsung UUID;
  product_macbook UUID;
  product_tshirt UUID;
  product_jeans UUID;
  product_coffee UUID;
  product_airfryer UUID;
  product_yoga UUID;
  product_dumbbells UUID;
  product_book UUID;
  user_id UUID;
  invoice_id UUID;
BEGIN
  -- Get product IDs
  SELECT id INTO product_iphone FROM products WHERE sku = 'IPH-15-PRO-001';
  SELECT id INTO product_samsung FROM products WHERE sku = 'SAM-S24-002';
  SELECT id INTO product_macbook FROM products WHERE sku = 'MBP-16-003';
  SELECT id INTO product_tshirt FROM products WHERE sku = 'TSH-CLR-004';
  SELECT id INTO product_jeans FROM products WHERE sku = 'DNM-JNS-005';
  SELECT id INTO product_coffee FROM products WHERE sku = 'COF-MKR-006';
  SELECT id INTO product_airfryer FROM products WHERE sku = 'AIR-FRY-007';
  SELECT id INTO product_yoga FROM products WHERE sku = 'YGA-MAT-008';
  SELECT id INTO product_dumbbells FROM products WHERE sku = 'DMB-SET-009';
  SELECT id INTO product_book FROM products WHERE sku = 'PRG-GDE-010';

  -- Get first user ID (or use your specific user ID)
  SELECT id INTO user_id FROM profiles LIMIT 1;

  -- Invoice 1: iPhone 15 Pro (1x)
  INSERT INTO invoices (invoice_number, customer_name, customer_phone, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-001', 'John Smith', '+1234567890', 'cash', 1199.99, 300.00, user_id, NOW() - INTERVAL '20 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_iphone, 'iPhone 15 Pro', 'IPH-15-PRO-001', 1, 1199.99, 899.99, 1199.99, 300.00);

  -- Invoice 2: Samsung Galaxy (2x)
  INSERT INTO invoices (invoice_number, customer_name, customer_phone, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-002', 'Sarah Johnson', '+1234567891', 'card', 1999.98, 500.00, user_id, NOW() - INTERVAL '19 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_samsung, 'Samsung Galaxy S24', 'SAM-S24-002', 2, 999.99, 749.99, 1999.98, 500.00);

  -- Invoice 3: MacBook Pro (1x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-003', 'Michael Brown', 'cash', 2499.99, 600.00, user_id, NOW() - INTERVAL '18 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_macbook, 'MacBook Pro 16"', 'MBP-16-003', 1, 2499.99, 1899.99, 2499.99, 600.00);

  -- Invoice 4: T-Shirts (5x)
  INSERT INTO invoices (invoice_number, customer_name, customer_phone, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-004', 'Emily Davis', '+1234567893', 'card', 124.95, 75.00, user_id, NOW() - INTERVAL '17 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_tshirt, 'Classic T-Shirt', 'TSH-CLR-004', 5, 24.99, 9.99, 124.95, 75.00);

  -- Invoice 5: Jeans (2x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-005', 'David Wilson', 'card', 119.98, 60.00, user_id, NOW() - INTERVAL '16 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_jeans, 'Denim Jeans', 'DNM-JNS-005', 2, 59.99, 29.99, 119.98, 60.00);

  -- Invoice 6: Coffee Maker (1x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-006', 'Lisa Anderson', 'cash', 89.99, 44.00, user_id, NOW() - INTERVAL '15 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_coffee, 'Coffee Maker', 'COF-MKR-006', 1, 89.99, 45.99, 89.99, 44.00);

  -- Invoice 7: Air Fryer (1x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-007', 'Robert Taylor', 'card', 129.99, 60.00, user_id, NOW() - INTERVAL '14 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_airfryer, 'Air Fryer', 'AIR-FRY-007', 1, 129.99, 69.99, 129.99, 60.00);

  -- Invoice 8: Yoga Mat (3x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-008', 'Jennifer Martinez', 'cash', 119.97, 72.00, user_id, NOW() - INTERVAL '13 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_yoga, 'Yoga Mat', 'YGA-MAT-008', 3, 39.99, 15.99, 119.97, 72.00);

  -- Invoice 9: Dumbbells (1x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-009', 'Christopher Lee', 'card', 149.99, 70.00, user_id, NOW() - INTERVAL '12 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_dumbbells, 'Dumbbells Set', 'DMB-SET-009', 1, 149.99, 79.99, 149.99, 70.00);

  -- Invoice 10: Programming Book (2x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-010', 'Amanda White', 'cash', 99.98, 50.00, user_id, NOW() - INTERVAL '11 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_book, 'Programming Guide', 'PRG-GDE-010', 2, 49.99, 24.99, 99.98, 50.00);

  -- Invoice 11: Mixed - iPhone + T-Shirt
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-011', 'Daniel Harris', 'card', 1224.98, 315.00, user_id, NOW() - INTERVAL '10 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES
    (invoice_id, product_iphone, 'iPhone 15 Pro', 'IPH-15-PRO-001', 1, 1199.99, 899.99, 1199.99, 300.00),
    (invoice_id, product_tshirt, 'Classic T-Shirt', 'TSH-CLR-004', 1, 24.99, 9.99, 24.99, 15.00);

  -- Invoice 12: Mixed - Coffee + Air Fryer
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-012', 'Jessica Clark', 'cash', 219.98, 104.00, user_id, NOW() - INTERVAL '9 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES
    (invoice_id, product_coffee, 'Coffee Maker', 'COF-MKR-006', 1, 89.99, 45.99, 89.99, 44.00),
    (invoice_id, product_airfryer, 'Air Fryer', 'AIR-FRY-007', 1, 129.99, 69.99, 129.99, 60.00);

  -- Invoice 13: Samsung (1x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-013', 'Matthew Lewis', 'card', 999.99, 250.00, user_id, NOW() - INTERVAL '8 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_samsung, 'Samsung Galaxy S24', 'SAM-S24-002', 1, 999.99, 749.99, 999.99, 250.00);

  -- Invoice 14: T-Shirts (10x)
  INSERT INTO invoices (invoice_number, customer_name, customer_phone, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-014', 'Ashley Walker', '+1234567894', 'cash', 249.90, 150.00, user_id, NOW() - INTERVAL '7 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_tshirt, 'Classic T-Shirt', 'TSH-CLR-004', 10, 24.99, 9.99, 249.90, 150.00);

  -- Invoice 15: Jeans (3x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-015', 'Joshua Hall', 'card', 179.97, 90.00, user_id, NOW() - INTERVAL '6 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_jeans, 'Denim Jeans', 'DNM-JNS-005', 3, 59.99, 29.99, 179.97, 90.00);

  -- Invoice 16: Mixed - Yoga Mat + Book
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-016', 'Stephanie Young', 'cash', 89.98, 49.00, user_id, NOW() - INTERVAL '5 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES
    (invoice_id, product_yoga, 'Yoga Mat', 'YGA-MAT-008', 1, 39.99, 15.99, 39.99, 24.00),
    (invoice_id, product_book, 'Programming Guide', 'PRG-GDE-010', 1, 49.99, 24.99, 49.99, 25.00);

  -- Invoice 17: MacBook (1x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-017', 'Kevin King', 'card', 2499.99, 600.00, user_id, NOW() - INTERVAL '4 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_macbook, 'MacBook Pro 16"', 'MBP-16-003', 1, 2499.99, 1899.99, 2499.99, 600.00);

  -- Invoice 18: Dumbbells (2x)
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-018', 'Nicole Wright', 'cash', 299.98, 140.00, user_id, NOW() - INTERVAL '3 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES (invoice_id, product_dumbbells, 'Dumbbells Set', 'DMB-SET-009', 2, 149.99, 79.99, 299.98, 140.00);

  -- Invoice 19: Mixed - iPhone + Samsung
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-019', 'Brandon Lopez', 'card', 2199.98, 550.00, user_id, NOW() - INTERVAL '2 days')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES
    (invoice_id, product_iphone, 'iPhone 15 Pro', 'IPH-15-PRO-001', 1, 1199.99, 899.99, 1199.99, 300.00),
    (invoice_id, product_samsung, 'Samsung Galaxy S24', 'SAM-S24-002', 1, 999.99, 749.99, 999.99, 250.00);

  -- Invoice 20: Mixed - Coffee + Yoga + Book
  INSERT INTO invoices (invoice_number, customer_name, payment_method, total_amount, total_profit, created_by, created_at)
  VALUES ('INV-2024-020', 'Rachel Scott', 'cash', 179.97, 93.00, user_id, NOW() - INTERVAL '1 day')
  RETURNING id INTO invoice_id;

  INSERT INTO invoice_items (invoice_id, product_id, product_name, product_sku, quantity, unit_price, unit_cost, subtotal, profit)
  VALUES
    (invoice_id, product_coffee, 'Coffee Maker', 'COF-MKR-006', 1, 89.99, 45.99, 89.99, 44.00),
    (invoice_id, product_yoga, 'Yoga Mat', 'YGA-MAT-008', 1, 39.99, 15.99, 39.99, 24.00),
    (invoice_id, product_book, 'Programming Guide', 'PRG-GDE-010', 1, 49.99, 24.99, 49.99, 25.00);

END $$;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check inserted data
SELECT 'Categories Count:' as label, COUNT(*) as count FROM categories
UNION ALL
SELECT 'Products Count:', COUNT(*) FROM products
UNION ALL
SELECT 'Invoices Count:', COUNT(*) FROM invoices
UNION ALL
SELECT 'Invoice Items Count:', COUNT(*) FROM invoice_items;

-- Show summary by category
SELECT
  p.category,
  COUNT(*) as product_count,
  SUM(p.quantity) as total_stock,
  SUM(p.quantity * p.price) as total_value


FROM products p
GROUP BY p.category
ORDER BY p.category;

-- Show sales summary
SELECT
  COUNT(*) as total_invoices,
  SUM(total_amount) as total_revenue,
  SUM(total_profit) as total_profit,
  AVG(total_amount) as avg_invoice_value,
  MIN(created_at) as first_sale,
  MAX(created_at) as last_sale
FROM invoices;

-- ============================================
-- NOTES
-- ============================================
--
-- 1. This script creates:
--    - 5 Categories (Electronics, Clothing, Home & Kitchen, Sports, Books)
--    - 10 Products (varied across categories)
--    - 20 Invoices (spread over 20 days)
--
-- 2. Product stock levels:
--    - 2 products are LOW STOCK (iPhone: 8, Samsung: 7)
--    - 8 products have adequate stock
--
-- 3. To run this script:
--    - Open Supabase SQL Editor
--    - Paste this entire script
--    - Click "Run"
--
-- 4. The script uses your first user from profiles table
--    If you want to use a specific user, replace the user_id query
--
-- 5. Invoices are backdated over 20 days for realistic timeline
--
-- ============================================
