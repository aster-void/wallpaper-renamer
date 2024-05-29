#!/usr/bin/env bash
# cd into where this file is
cd $(dirname $0)

paths=()
for path in ./storage/new/*; do
  paths+=("$path")
done

exit_flag=false
for path in "${paths[@]}"; do
  if [[ $path == *.png ]]; then
    :
  elif [[ $path == *.jpg ]]; then
    :
  elif [[ $path == *.jpeg ]]; then
    echo "*.jpeg found."
    echo "renaming it to jpg..."
    exit 1 # TODO: rename it to jpg
  else
    echo "this file has unknown extension: $path"
    exit_flag=true
  fi
done
if $exit_flag; then
  echo "exitting..."
  exit 1
fi

for path in "${paths[@]}"; do
  filename=$(basename -- "$path")
  ext="${filename##*.}"
  name="${filename%.*}"
  hash=$(sha256sum -- "$path" | head -c 16)
  hashed_name=${hash}.${ext}
  ln -s ../data/$hashed_name ./storage/aliases/$filename
done
