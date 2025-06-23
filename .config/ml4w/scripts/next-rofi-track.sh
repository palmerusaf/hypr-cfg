#!/bin/bash

SOCK="/tmp/mpvsock"

# Get current song title
SONG_INFO=$(echo '{ "command": ["get_property", "media-title"] }' | socat - $SOCK)

# Extract title from JSON
CUR_TITLE=$(echo "$SONG_INFO" | grep -oP '"data":\s*"\K[^"]+')

# Send skip command
RESPONSE=$(echo '{ "command": ["playlist-next"] }' | socat - $SOCK)

# Check if skip was successful
if echo "$RESPONSE" | grep -q '"success"'; then
	# Get current song title
	SONG_INFO=$(echo '{ "command": ["get_property", "media-title"] }' | socat - $SOCK)

	# Extract title from JSON
	TITLE=$(echo "$SONG_INFO" | grep -oP '"data":\s*"\K[^"]+')

	# Notify the user
	notify-send -e "⏭️🎵 Skipping '$CUR_TITLE'"
  sleep 3
  notify-send -e "▶️🎵 Next Song '$TITLE'"
else
	notify-send -e "⚠️ MPV" "Cannot skip '$CUR_TITLE' – no next song or error occurred."
fi
