#!/usr/bin/env bash
# cd into where this file is
cd $(dirname $0)

paths=()
for path in ./storage/new/*; do
  paths+=("$path")
done

for path in "${paths[@]}"; do
  filename=$(basename -- "$path")
  ext="${filename##*.}"
  hash=$(sha256sum -- "$path" | head -c 16)
  hashed_name=${hash}.${ext}
  mv "./storage/new/$filename" "./storage/unnamed/$hashed_name"
done
