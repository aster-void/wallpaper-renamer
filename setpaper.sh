#!/usr/bin/env bash

dirname="$HOME/wallpaper"

monitors=(`(cd $dirname; cat ./monitors.local)`)

if [ ! -f ${dirname}/storage/aliases/$1 ]; then
  echo "File not found! looked at: ${dirname}/storage/aliases/$1"
  exit 1
fi

hyprctl hyprpaper preload ${dirname}/storage/aliases/$1
for monitor in ${monitors[@]}; do
  hyprctl hyprpaper wallpaper "${monitor},${dirname}/storage/aliases/$1"
done
