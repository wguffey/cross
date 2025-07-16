-- run once (psql -U mochi -d mochidb -f schema.sql)
CREATE TABLE decks (
  deck_id  TEXT PRIMARY KEY,
  name     TEXT
);

CREATE TABLE cards (
  card_id    TEXT PRIMARY KEY,
  deck_id    TEXT REFERENCES decks(deck_id),
  created_at TIMESTAMPTZ,
  content    TEXT
);

CREATE TABLE reviews (
  id            BIGSERIAL PRIMARY KEY,
  card_id       TEXT REFERENCES cards(card_id),
  review_at     TIMESTAMPTZ,     -- Grafana’s $__time column
  rating        TEXT,            -- easy / good / hard / fail
  interval_days INTEGER,
  ease          REAL,
  duration      INTEGER
);

CREATE UNIQUE INDEX uniq_review ON reviews(card_id, review_at);
CREATE INDEX ON reviews(review_at);
CREATE INDEX ON reviews(card_id);
