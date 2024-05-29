#!/usr/bin/env bash
cd $(dirname -- "$0")
dir=$(pwd)
monitors=(`(cd $dir; cat ./monitors.local)`)

path="${dir}/storage/$1"
if [ ! -f "$path" ]; then
  echo "File not found! looked at: ${dir}/storage/$1"
  exit 1
fi

hyprctl hyprpaper preload "${path}"
for monitor in "${monitors[@]}"; do
  hyprctl hyprpaper wallpaper "${monitor},${path}"
done
