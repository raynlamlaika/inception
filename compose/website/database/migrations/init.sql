-- Up: create user_inputs table to store incoming messages
CREATE TABLE IF NOT EXISTS user_inputs (
	id SERIAL PRIMARY KEY,
	content TEXT NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Down (optional manual step):
-- DROP TABLE IF EXISTS user_inputs;

\password postgres
