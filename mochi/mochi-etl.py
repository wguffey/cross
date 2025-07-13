import sqlite3, json, math, datetime as dt, psycopg2, os, pathlib

SRC_DB = pathlib.Path("mochi.db")
PG_DSN = os.getenv(
    "PG_DSN", "postgresql://mochi:secret@localhost:5432/mochidb"
)
MS_DAY = 86_400_000


def ms_to_dt(raw):
    if isinstance(raw, (int, float)):
        return dt.datetime.utcfromtimestamp(raw / 1000)
    return dt.datetime.utcfromtimestamp(int(raw[2:]) / 1000)


def interval_of(r):
    if "~:interval" in r:
        return r["~:interval"]
    if "~:due" in r and "~:date" in r:
        return round((int(r["~:due"][2:]) - int(r["~:date"][2:])) / MS_DAY)
    return None


src = sqlite3.connect(SRC_DB)
pg = psycopg2.connect(PG_DSN)
pg.autocommit = False
cur_pg = pg.cursor()

# decks
for (blob,) in src.execute(
    'SELECT json FROM "by-sequence" WHERE json LIKE \'%"type":"deck"%\''
):
    td = json.loads(blob)["transit-data"]
    cur_pg.execute(
        "INSERT INTO decks(deck_id,name) VALUES (%s,%s) ON CONFLICT DO NOTHING",
        (td["~:id"], td["~:name"]),
    )

# cards & reviews
for (blob,) in src.execute(
    'SELECT json FROM "by-sequence" WHERE json LIKE \'%"type":"card"%\''
):
    td = json.loads(blob)["transit-data"]
    deck = td["~:deck-id"]

    cur_pg.execute(
        """INSERT INTO cards(card_id,deck_id,created_at,content)
           VALUES (%s,%s,%s,%s)
           ON CONFLICT (card_id) DO NOTHING""",
        (
            td["~:id"],
            deck,
            ms_to_dt(td["~:created-at"]["~#dt"]),
            td.get("~:content"),
        ),
    )

    for r in td["~:reviews"]:
        cur_pg.execute(
            """INSERT INTO reviews(card_id,review_at,rating,interval_days,ease)
               VALUES (%s,%s,%s,%s,%s)""",
            (
                td["~:id"],
                ms_to_dt(r["~:date"]),
                r.get("~:rating")
                or ("good" if r.get("~:remembered?") else "fail"),
                interval_of(r),
                r.get("~:ease"),
            ),
        )

pg.commit()
print("ETL finished.")
