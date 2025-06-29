# Hyprland_Dotfiles
This repository contains my personal Hyprland dotfiles, which are tailored for my specific setup and preferences. The configuration is designed to work with the Hyprland window manager and includes various customizations for a personalized user experience.

# Installation


## Needed packages move to waybar

Nerd Fonts used for the icons in the status bar, so you need to install them first.
```
sudo pacman -S nerd-fonts-jetbrains-mono
```

Or download all Nerd Fonts 
```
sudo pacman -S nerd-fonts
```

## Rofi 
1. make executable 

```
chod +x wifi-manager.sh 
```

2. Install dependencies (if not already installed):
```
sudo pacman -S rofi networkmanager libnotify
``` 

3. Ensure NetworkMangager is running:
```
sudo systemctl enable --now NetworkManager

```


## Waybar
The source of inspiration for the waybar 
- https://github.com/AslanLM/hypr-dotfiles


## Display Manager 
Alternatives 
1. SDDM
    - https://github.com/stepanzubkov/where-is-my-sddm-theme
2. Ly 
    - https://github.com/fairyglade/ly
 ### TTY
 autologin to TTY and start Hyprland from there. 
    
```bash 
nvim ~/.bash_profile
```

Lim inn 
```bash
if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland

exec Hyprland
fi
``` 

**Toggle** autologin on off 
- Toggle off 
```bash
sudo systemctl revert getty@tty1
``` 
- Toggle on 
```bash 
sudo systemctl edit getty@tty1
```
Then add the following lines:
```bash 
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin domest --noclear %I $TERM
```
# Packages 
- Foliate -> Book reader
- Dolphin -> File manager
- Yazi -> File manager
- Pyprland -> Hyprland configuration manager
- Hyprpaper -> Wallpaper manager
- Hyprsunset -> remove blue light
- p7zip -> unzip files
