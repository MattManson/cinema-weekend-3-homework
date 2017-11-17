DROP TABLE tickets;
DROP TABLE customers;
DROP TABLE films;



CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255),
  price INT4
);

-- CREATE TABLE screenings(
--   id SERIAL4 PRIMARY KEY,
--   film_id INT4 REFERENCES films(id)
--   start_time
-- )

CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  film_id INT4 REFERENCES films(id),
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE
);