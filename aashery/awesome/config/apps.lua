local apps = {
    terminal = "kitty", 
    launcher = "sh /home/aashery/.config/rofi/launch.sh", 
    xrandr = "lxrandr", 
    screenshot = "scrot -e 'echo $f'", 
    volume = "pavucontrol", 
    appearance = "lxappearance", 
    browser = "firefox", 
    fileexplorer = "thunar",
    musicplayer = "pragha", 
    settings = "code /home/parndt/awesome/",
    locker = "betterlockscreen -l"
}

user = {
    terminal = "kitty", 
    floating_terminal = "kitty"
}

return apps
