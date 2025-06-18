#! /bin/bash

echo '{ "command": ["playlist-next"] }' | socat - /tmp/mpvsock # skip to next song
