#!/usr/bin/env bash
dir="$HOME/wallpaper"

if [ -f "${dir}/storage/wallpaper.jpg" ]; then
  ext="jpg"
elif [ -f "${dir}/storage/wallpaper.png" ]; then
  ext="png"
else
  echo "Unknown extension. $(ls "${dir}/storage/" | grep wallpaper)"
fi

echo "Reloading wallpaper: ${dir}/storage/wallpaper.${ext}..."
hyprctl hyprpaper preload ${dir}/storage/wallpaper.${ext}
hyprctl hyprpaper wallpaper "DP-1,${dir}/storage/wallpaper.${ext}"
