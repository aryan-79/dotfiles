#!/bin/sh

DESTINATION="$HOME/.config/hypr/wallpaper"

if [ -z "$1" ]; then
  echo "Usage: $0 <file-path>"
  exit 1
fi

SOURCE_FILE="$1"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "File not found: $SOURCE_FILE"
  exit 1
fi

EXT="${SOURCE_FILE##*.}"
TARGET_NAME="active.$EXT"
TARGET_PATH="$DESTINATION/$TARGET_NAME"

mkdir -p "$DESTINATION"
rm -f "$DESTINATION/active."*

cp "$SOURCE_FILE" "$TARGET_PATH"

wallust run "$TARGET_PATH"

hyprctl hyprpaper preload "$TARGET_PATH"
hyprctl hyprpaper wallpaper " ,$TARGET_PATH"
hyprctl hyprpaper unload all

pkill waybar
waybar &

notify-send -i palette \
  "Wallpaper changed" \
  "Now using $(basename "$SOURCE_FILE")"
