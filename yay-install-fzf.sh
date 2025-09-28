#!/bin/bash

fzf_args=(
  --multi
  --preview 'yay -Sii {1}'
  --preview-label='alt-p: toggle description, alt-j/k: scroll, tab: multi-select, F11: maximize'
  --preview-label-pos='bottom'
  --preview-window 'down:65%:wrap'
  --bind 'alt-p:toggle-preview'
  --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
  --bind 'alt-k:preview-up,alt-j:preview-down'
  --color 'pointer:green,marker:green'
)

pkg_names=$(yay -Slq | fzf "${fzf_args[@]}")

if [[ -n "$pkg_names" ]]; then
  # Turn newline-separated into array
  readarray -t packages <<<"$pkg_names"

  # Run yay interactively with all packages at once
  yay -S "${packages[@]}"
  killall cosmic-launcher
fi

