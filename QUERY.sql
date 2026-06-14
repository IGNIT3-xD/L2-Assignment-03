-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;

DROP TABLE IF EXISTS Matches;

DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
  user_id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  role VARCHAR(50) CHECK (role IN ('Ticket Manager', 'Football Fan')) NOT NULL,
  phone_number VARCHAR(50)
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
  match_id SERIAL PRIMARY KEY,
  fixture VARCHAR(255) NOT NULL,
  tournament_category VARCHAR(255) NOT NULL,
  base_ticket_price INT NOT NULL CHECK (base_ticket_price >= 0),
  match_status VARCHAR(50) NOT NULL CHECK (
    match_status IN (
      'Available',
      'Selling Fast',
      'Sold Out',
      'Postponed'
    )
  )
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES Users (user_id) ON DELETE CASCADE,
  match_id INT REFERENCES Matches (match_id) ON DELETE CASCADE,
  seat_number VARCHAR(50),
  payment_status VARCHAR(50) CHECK (
    payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
  ),
  total_cost NUMERIC(10, 2) CHECK (total_cost >= 0) NOT NULL
);