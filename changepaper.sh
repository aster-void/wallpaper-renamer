#!/usr/bin/env bash
dir="$(cd $(dirname -- $0); pwd)"
cd $dir

# assertions
if [ ! -f ${dir}/storage/$1 ]; then
  echo "file '$1' not found!"
  exit 1
fi
if [[ $1 == *.png ]]; then
  ext="png"
elif [[ $1 == *.jpg ]]; then
  ext="jpg"
else
  echo "unknown extension!"
  exit 1
fi

# delete previous wallpapers
rm ./storage/wallpaper.jpg 2>/dev/null
rm ./storage/wallpaper.png 2>/dev/null

cp ./storage/$1 ./storage/wallpaper.${ext}

./reloadpaper.sh
