# wallpaper-renamer

shell scripts in this repo is built for hyprpaper.

## Initialize

run ./init.sh

edit monitor.local to fit your monitor names, separated by space.
 
## how to use

put everything in ./storage/new/

if you like them, name it yourself and put it at ./storage/
if not, leave it there.

once you are satisfied, run ./main.sh
this will rename everything in ./storage/new/ to its corresponding SHA256 hash | head -c 16
  and move them to ./storage/unnamed.

