#!/bin/bash
SELECTED_LINK=$(cat /Users/farid/flink-links.txt | choose | awk "{print $1}")
if [ "$SELECTED_LINK" != "" ] && [ "$SELECTED_LINK" == "#todo" ]; then
  WEZTERM_TAB_ID=$(aerospace list-windows --all | grep "WezTerm" | awk '{ print $1 }')
  aerospace focus --window-id $WEZTERM_TAB_ID && wezterm cli activate-pane --pane-id=0
elif [ "$SELECTED_LINK" != "" ] && [ "$SELECTED_LINK" == "#mute-toggle" ] ; then
  aerospace volume mute-toggle
elif [ "$SELECTED_LINK" != "" ] && [ "$SELECTED_LINK" == "#github" ] ; then
  # gh repo list goflink --no-archived --limit 1000 > github-links.txt
  cat /Users/farid/github-links.txt | choose | awk '{print "https://github.com/"$1}' | xargs open
elif [ "$SELECTED_LINK" != "" ] && [ "$SELECTED_LINK" == "#meet" ] ; then
  wezterm cli spawn /Users/farid/.config/my-bash-scripts/my-google-meet.sh
elif [ "$SELECTED_LINK" != "" ] && [ "$SELECTED_LINK" == "#screenshots" ] ; then
  open -a Screenshot
elif [ "$SELECTED_LINK" != "" ] ; then
  open "$SELECTED_LINK"
fi
# TODO
# - Open a Jira ticket
# - Open a new terminal tab with curl wttr.in/berlin
