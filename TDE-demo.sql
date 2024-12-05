
SELECT * FROM pg_extension WHERE extname = 'pgcrypto';
CREATE EXTENSION IF NOT EXISTS pgcrypto;


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255),
    ssn VARCHAR(15)
);

-- Alter the columns to change them to bytea type with explicit casting
ALTER TABLE users
  ALTER COLUMN email SET DATA TYPE bytea USING email::bytea,
  ALTER COLUMN ssn SET DATA TYPE bytea USING ssn::bytea;



-- Encrypting data using pgcrypto
INSERT INTO users (email, ssn) 
VALUES (
  pgp_sym_encrypt('user@example.com', 'encryption_key'), 
  pgp_sym_encrypt(SUBSTRING('123-45-6789' FROM 1 FOR 11), 'encryption_key')
);


-- Decrypting data
SELECT 
  pgp_sym_decrypt(email, 'encryption_key') AS decrypted_email,
  pgp_sym_decrypt(ssn, 'encryption_key') AS decrypted_ssn
FROM users;

