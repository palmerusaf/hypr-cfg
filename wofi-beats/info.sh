#!/bin/bash

SOCK="/tmp/mpvsock"

# Get current song title
SONG_INFO=$(echo '{ "command": ["get_property", "media-title"] }' | socat - $SOCK)
# Extract title from JSON
TITLE=$(echo "$SONG_INFO" | grep -oP '"data":\s*"\K[^"]+')
notify-send -e "🎵 Currently Playing - '$TITLE'"
