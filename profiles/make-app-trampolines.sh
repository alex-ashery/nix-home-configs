# Credit: https://github.com/nix-community/home-manager/issues/1341#issuecomment-1705731962
# That author wrote https://github.com/hraban/mac-app-util.
# App linking based on:
# https://github.com/nix-community/home-manager/issues/1341#issuecomment-1870352014
fromDir="$HOME/.nix-profile/Applications/Home Manager Apps"
toDir="$HOME/Applications/Home Manager Apps"
mkdir -p "$toDir"

find "$toDir" -type l -delete

if [ -d "$fromDir" ]; then
  find "$fromDir" -maxdepth 1 -type l | while read -r app; do
    target="$(readlink "$app")"
    appName="$(basename "$app")"
    trampoline="$toDir/$appName"
    /usr/bin/osacompile -o "$trampoline" -e "do shell script \"open '$target'\""
  done
fi
