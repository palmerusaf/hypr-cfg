#!/usr/bin/env bash
for i in ~/dotfiles/*/; do
  ln -s $i ../.config/
done
