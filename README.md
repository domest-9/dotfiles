# Hyprland_Dotfiles

# The source of inspiration for the waybar 
-https://github.com/AslanLM/hypr-dotfiles

# Installation


## Needed packages

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