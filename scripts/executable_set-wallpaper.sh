#!/bin/sh

DESTINATION="$HOME/.config/hypr/wallpaper"

# Extract the extension (e.g., .jpg, .png)
EXT="${1##*.}"
TARGET_NAME="active.$EXT"
TARGET_PATH="$DESTINATION/$TARGET_NAME"

if [ -z "$1" ]; then
  echo "Usage: $0 <file-path>"
  exit 1
fi

SOURCE_FILE="$1"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "File not found"
  exit 1
fi

mkdir -p "$DESTINATION"

# Clean up any OLD 'active' files with different extensions
# This prevents having active.jpg AND current_wallpaper.png
rm -f "$DESTINATION/active".*

# Perform the copy
cp "$SOURCE_FILE" "$TARGET_PATH"

wallust run "$DESTINATION/active.$EXT"

hyprctl dispatch exec hyprpaper

pkill waybar
waybar &

notify-send -i palette \
  "Wallpaper changed" \
  "Now using $(basename "$SOURCE_FILE")"
