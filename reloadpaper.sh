#!/usr/bin/env bash
cd $(dirname -- "$0")
dir=$(pwd)
monitors=(`(cd $dir; cat ./monitors.local)`)

if [ -f "${dir}/storage/wallpaper.jpg" ]; then
  ext="jpg"
elif [ -f "${dir}/storage/wallpaper.png" ]; then
  ext="png"
else
  echo "Unknown extension or file not found: $(ls "${dir}/storage/" | grep wallpaper)"
  exit 1
fi

path_without_ext="${dir}/storage/wallpaper"
path="${dir}/storage/wallpaper.${ext}"

echo "Reloading wallpaper: ${path}..."
hyprctl hyprpaper unload "${path_without_ext}.jpg"
hyprctl hyprpaper unload "${path_without_ext}.png"
hyprctl hyprpaper preload "${path}"

for monitor in "${monitors[@]}"; do
  hyprctl hyprpaper wallpaper "${monitor},${path}"
done

