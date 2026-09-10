# Credit: https://github.com/nix-community/home-manager/issues/1341#issuecomment-1705731962
# That author wrote https://github.com/hraban/mac-app-util.
# App linking based on:
# https://github.com/nix-community/home-manager/issues/1341#issuecomment-1870352014
fromDir="$HOME/Applications/Home Manager Apps"
toDir="$HOME/Applications/Home Manager Trampolines"
mkdir -p "$toDir"

if [ -d "$fromDir" ]; then
  find -L "$fromDir" -maxdepth 1 -type d -name '*.app' | while read -r app; do
    appName="$(basename "$app")"
    bundleName="${appName%.app}"
    bundleIdPart="$(printf '%s' "$bundleName" | tr -cs '[:alnum:]' '-' | tr '[:upper:]' '[:lower:]' | sed 's/^-//; s/-$//')"
    trampoline="$toDir/$appName"
    rm -rf "$trampoline"
    /usr/bin/osacompile -o "$trampoline" -e "do shell script \"open '$app'\""
    /usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string org.home-manager.trampoline.$bundleIdPart" "$trampoline/Contents/Info.plist"

    # Just clobber the applet icon laid down by osacompile rather than do
    # surgery on the plist.
    icon="$(find "$app/Contents/Resources" -maxdepth 1 -name '*.icns' -print -quit)"
    if [ -n "$icon" ]; then
      cp "$icon" "$trampoline/Contents/Resources/applet.icns"
    fi

    # Replacing applet.icns mutates a sealed resource in the applet bundle that
    # osacompile just signed. Re-sign so LaunchServices/Spotlight can trust the
    # bundle metadata and display the copied icon.
    /usr/bin/codesign --force --deep --sign - "$trampoline"
    touch "$trampoline"
  done

  # Cleanup trampolines for apps Home Manager no longer exposes.
  find "$toDir" -maxdepth 1 -type d -name '*.app' | while read -r app; do
    appName="$(basename "$app")"
    if [ ! -d "$fromDir/$appName" ]; then
      rm -rf "$app"
    fi
  done
fi
