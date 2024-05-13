#!/usr/bin/env bash

dirname="$HOME/wallpaper"

if [[ $1 == *.png ]]; then
  ext="png"
elif [[ $1 == *.jpg ]]; then
  ext="jpg"
else
  echo "unknown extension!"
  exit 1
fi

# delete previous wallpapers
rm ${dirname}/storage/wallpaper.jpg 2>/dev/null
rm ${dirname}/storage/wallpaper.png 2>/dev/null

if [ ! -f ${dirname}/storage/aliases/$1 ]; then
  echo "file '$1' not found!"
  exit 1
fi

cp ${dirname}/storage/aliases/$1 ${dirname}/storage/wallpaper.${ext}

# TODO: change this to reloadpaper.sh
./reloadpaper.sh
