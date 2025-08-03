"""
Dump daily learned + review counts into JSON for my website.
"""

import datetime as dt
import json
import os
import pathlib

import psycopg2


def run():
    DST_JSON = pathlib.Path(
        "/Users/williamguffey/workspace/wguffey-website/stats/mochi_daily.json"
    )

    conn = psycopg2.connect(os.getenv("PG_DSN_MOCHI"))
    cur = conn.cursor()

    cur.execute(
        """
    WITH learned_cards AS (
        SELECT MIN(review_at)::date AS day
        FROM reviews
        GROUP BY card_id
    ),
    daily_learned AS (
        SELECT day, COUNT(*) AS learned
        FROM learned_cards
        GROUP BY day
    ),
    daily_reviewed AS (
        SELECT review_at::date AS day, COUNT(*) AS reviewed
        FROM reviews
        GROUP BY day
    )
    SELECT
        COALESCE(l.day, r.day) AS day,
        COALESCE(learned, 0)   AS learned,
        COALESCE(reviewed, 0)  AS reviewed
    FROM daily_learned l
    FULL JOIN daily_reviewed r USING (day)
    ORDER BY day;
    """
    )

    rows = [
        dict(zip(("day", "learned", "reviewed"), row))
        for row in cur.fetchall()
    ]
    DST_JSON.parent.mkdir(parents=True, exist_ok=True)
    DST_JSON.write_text(json.dumps(rows, indent=2, default=str))
    print("exported", len(rows), "rows to", DST_JSON)


if __name__ == "__main__":
    run()
