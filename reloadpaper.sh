#!/usr/bin/env bash
dir="$HOME/wallpaper"
monitors=(`cat ./monitors.local`)

if [ -f "${dir}/storage/wallpaper.jpg" ]; then
  ext="jpg"
elif [ -f "${dir}/storage/wallpaper.png" ]; then
  ext="png"
else
  echo "Unknown extension. $(ls "${dir}/storage/" | grep wallpaper)"
fi

path="${dir}/storage/wallpaper.${ext}"

echo "Reloading wallpaper: ${path}"

hyprctl hyprpaper unload ${path}
hyprctl hyprpaper preload ${path}

for monitor in ${monitors[@]}; do
  hyprctl hyprpaper wallpaper "${monitor},${path}"
done
