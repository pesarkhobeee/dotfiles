#!/bin/bash
HIST_SRC="$HOME/Library/Application Support/Vivaldi/Default/History"
HIST_TMP="/tmp/vivaldi-history-$$.db"
MAP_TMP="/tmp/vivaldi-history-$$.tsv"

cp "$HIST_SRC" "$HIST_TMP" || exit 1

sqlite3 -separator $'\t' "$HIST_TMP" \
  "SELECT title, url FROM urls WHERE hidden = 0 AND title != '' GROUP BY title ORDER BY MAX(last_visit_time) DESC LIMIT 5000;" \
  > "$MAP_TMP"

SELECTED_TITLE=$(cut -f1 "$MAP_TMP" | choose -n 20 -w 120)

if [ -n "$SELECTED_TITLE" ]; then
  SELECTED_URL=$(awk -F'\t' -v t="$SELECTED_TITLE" '$1 == t {print $2; exit}' "$MAP_TMP")
  [ -n "$SELECTED_URL" ] && open "$SELECTED_URL"
fi

rm -f "$HIST_TMP" "$MAP_TMP"
exit 0
