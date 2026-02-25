-- create demo user/db are handled by container env vars; create schema, table, history, trigger

CREATE TABLE IF NOT EXISTS items (
  id serial PRIMARY KEY,
  name text NOT NULL,
  qty int NOT NULL,
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS items_history (
  hid serial PRIMARY KEY,
  operation char(1) NOT NULL, -- I/U/D
  changed_at timestamptz DEFAULT now(),
  id int,
  name text,
  qty int
);

CREATE OR REPLACE FUNCTION items_audit() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO items_history (operation, id, name, qty, changed_at)
      VALUES ('D', OLD.id, OLD.name, OLD.qty, now());
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO items_history (operation, id, name, qty, changed_at)
      VALUES ('U', NEW.id, NEW.name, NEW.qty, now());
    RETURN NEW;
  ELSE
    INSERT INTO items_history (operation, id, name, qty, changed_at)
      VALUES ('I', NEW.id, NEW.name, NEW.qty, now());
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS items_audit_tr ON items;
CREATE TRIGGER items_audit_tr
  AFTER INSERT OR UPDATE OR DELETE ON items
  FOR EACH ROW EXECUTE FUNCTION items_audit();