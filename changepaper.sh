#!/usr/bin/env bash

dirname="/home/aster/wallpaper"
if [[ $1 == *.png ]]; then
  ext="png"
elif [[ $1 == *.jpg ]]; then
  ext="jpg"
else
  echo "unknown extension!"
  exit 1
fi

if [ ! -f ${dirname}/storage/aliases/$1 ]; then
  echo "file '$1' not found!"
  exit 1
fi

cp ${dirname}/storage/aliases/$1 ${dirname}/storage/wallpaper.${ext}

# TODO: change this to reloadpaper.sh
./setpaper.sh ../wallpaper.${ext}
