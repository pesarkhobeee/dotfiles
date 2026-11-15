#!/bin/bash
# Usage: my-browser-history.sh [frecent|recent]
HIST_SRC="$HOME/Library/Application Support/Vivaldi/Default/History"
MODE="${1:-frecent}"

TMP_DIR=$(mktemp -d) || exit 1
trap 'rm -rf "$TMP_DIR"' EXIT

cp "$HIST_SRC" "$TMP_DIR/history.db" || exit 1

# Chromium stores last_visit_time as microseconds since 1601-01-01.
LAST_VISIT_UNIX="(last_visit_time / 1000000 - 11644473600)"
AGE_DAYS="((strftime('%s','now') - $LAST_VISIT_UNIX) / 86400.0)"
if [ "$MODE" = "recent" ]; then
  ORDER="last_visit_time DESC"
else
  ORDER="(visit_count + typed_count * 2) / (1.0 + $AGE_DAYS / 3.0) DESC"
fi

# Truncation happens in SQLite because BSD awk cuts by bytes and breaks UTF-8, which makes choose exit silently.
sqlite3 -separator $'\t' "$TMP_DIR/history.db" "
  SELECT url,
         replace(replace(substr(CASE WHEN title = '' THEN url ELSE title END, 1, 70), char(9), ' '), char(10), ' ')
           || '  ·  ' || substr(replace(replace(url, 'https://', ''), 'http://', ''), 1, 90)
  FROM urls
  WHERE hidden = 0 AND (url LIKE 'http://%' OR url LIKE 'https://%')
  ORDER BY $ORDER
  LIMIT 5000;" > "$TMP_DIR/rows.tsv"

INDEX=$(cut -f2 "$TMP_DIR/rows.tsv" | choose -i -n 20 -w 140 -p "History ($MODE)")

[[ "$INDEX" =~ ^[0-9]+$ ]] || exit 0
URL=$(sed -n "$((INDEX + 1))p" "$TMP_DIR/rows.tsv" | cut -f1)
[ -n "$URL" ] && open "$URL"
exit 0
