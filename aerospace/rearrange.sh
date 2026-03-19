#!/usr/bin/env bash

# Rearrange all windows to their assigned workspaces
# based on [[on-window-detected]] rules in aerospace.toml

get_target_workspace() {
  case "$1" in
    com.github.wez.wezterm)         echo "1" ;;
    com.tinyspeck.slackmacgap)      echo "2" ;;
    com.vivaldi.Vivaldi)            echo "3" ;;
    com.google.Chrome)              echo "3" ;;
    org.mozilla.firefox)            echo "4" ;;
    dev.zed.Zed)                    echo "5" ;;
    com.spotify.client)             echo "6" ;;
    com.anthropic.claudefordesktop) echo "7" ;;
    ru.keepcoder.Telegram)          echo "8" ;;
    md.obsidian)                    echo "9" ;;
  esac
}

# Get all windows: window-id | app-bundle-id
aerospace list-windows --all --format "%{window-id}|%{app-bundle-id}" | while IFS='|' read -r wid app_id; do
  app_id=$(echo "$app_id" | xargs)
  target=$(get_target_workspace "$app_id")
  if [ -n "$target" ]; then
    aerospace move-node-to-workspace --window-id "$wid" "$target" 2>/dev/null
  fi
done

# Notify sketchybar to refresh
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
