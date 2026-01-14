#!/usr/bin/env bash
# /home/branden/dotfiles/vol-fix/down.sh
amixer -q -c 2 sset Master 100%
amixer -q -c 2 sset Speaker 100%
amixer -q -c 2 sset PCM 5%-
