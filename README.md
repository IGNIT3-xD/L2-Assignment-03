# 🏟️ Football Ticket Booking System — Database Design & SQL Queries

A relational database project built with **PostgreSQL** that models a football ticket booking platform. It covers schema design, constraints, relationships, and practical SQL queries.

---

## 📐 Entity Relationship Diagram (ERD)

🔗 [View ERD on DrawSQL](https://drawsql.app/teams/imran-here/diagrams/assignment-03-football-ticket-booking-system)

### Tables

| Table      | Description                                      |
|------------|--------------------------------------------------|
| `Users`    | Stores football fans and ticket managers         |
| `Matches`  | Stores match fixtures, categories, and pricing   |
| `Bookings` | Junction table linking users to matches          |

### Relationships

- **One to Many** — One `User` → Many `Bookings` (a fan can buy tickets for multiple matches)
- **Many to One** — Many `Bookings` → One `Match` (a match can have thousands of bookings)
- **Junction** — Each `Booking` row maps exactly one user to one match for a specific seat

---

## 🗂️ Schema Overview

### Users
```sql
CREATE TABLE Users (
  user_id      SERIAL PRIMARY KEY,
  full_name    VARCHAR(255) NOT NULL,
  email        VARCHAR(255) NOT NULL UNIQUE,
  role         VARCHAR(50) CHECK (role IN ('Ticket Manager', 'Football Fan')) NOT NULL,
  phone_number VARCHAR(50)
);
```

### Matches
```sql
CREATE TABLE Matches (
  match_id             SERIAL PRIMARY KEY,
  fixture              VARCHAR(255) NOT NULL,
  tournament_category  VARCHAR(255) NOT NULL,
  base_ticket_price    INT NOT NULL CHECK (base_ticket_price >= 0),
  match_status         VARCHAR(50) NOT NULL CHECK (
    match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed')
  )
);
```

### Bookings
```sql
CREATE TABLE Bookings (
  booking_id     SERIAL PRIMARY KEY,
  user_id        INT REFERENCES Users(user_id) ON DELETE CASCADE,
  match_id       INT REFERENCES Matches(match_id) ON DELETE CASCADE,
  seat_number    VARCHAR(50),
  payment_status VARCHAR(50) CHECK (
    payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
  ),
  total_cost     NUMERIC(10,2) CHECK (total_cost >= 0) NOT NULL
);
```

---

## 🔍 SQL Queries

### Query 1 — Available Champions League Matches
Retrieve all matches in the Champions League where status is `Available`.
```sql
SELECT match_id, fixture, base_ticket_price FROM matches
WHERE tournament_category = 'Champions League' AND match_status = 'Available';
```

### Query 2 — Search Users by Name (Case-Insensitive)
Find users whose name starts with `Tanvir` or contains `Haque`.
```sql
SELECT user_id, full_name, email FROM users
WHERE full_name ILIKE 'Tanvir%' OR full_name ILIKE '%Haque%';
```

### Query 3 — Bookings with Missing Payment Status
Replace NULL payment status with `'Action Required'` using `COALESCE`.
```sql
SELECT booking_id, user_id, match_id,
  COALESCE(payment_status, 'Action Required') AS systematic_status
FROM bookings
WHERE payment_status IS NULL;
```

### Query 4 — Booking Details with User and Match Info
Join all three tables to get a full booking summary.
```sql
SELECT booking_id, full_name, fixture, total_cost FROM bookings
JOIN users USING(user_id)
JOIN matches USING(match_id);
```

### Query 5 — All Users Including Those Without Bookings
Use `LEFT JOIN` to ensure fans with no tickets still appear.
```sql
SELECT users.user_id, full_name, booking_id
FROM users
LEFT JOIN bookings ON users.user_id = bookings.user_id;
```

### Query 6 — Bookings Above Average Cost
Use a subquery to find bookings more expensive than the average.
```sql
SELECT booking_id, match_id, total_cost FROM bookings
WHERE total_cost > (SELECT AVG(total_cost) FROM bookings);
```

### Query 7 — 2nd and 3rd Most Expensive Matches
Skip the highest priced match using `OFFSET`.
```sql
SELECT match_id, fixture, base_ticket_price FROM matches
ORDER BY base_ticket_price DESC LIMIT 2 OFFSET 1;
```

---

## 🛠️ Key Concepts Used

- `CHECK` constraints for enums (role, match_status, payment_status)
- `SERIAL` with custom start values for readable IDs (`match_id` from 101, `booking_id` from 501)
- `ON DELETE CASCADE` for referential integrity
- `COALESCE` for NULL handling
- `ILIKE` for case-insensitive pattern matching
- `LEFT JOIN` to include users with no bookings
- Subquery with `AVG()` for aggregate filtering
- `LIMIT` + `OFFSET` for pagination-style results

---

## 💻 Tech Stack

- **Database:** PostgreSQL
- **ERD Tool:** DrawSQL