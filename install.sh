#!/bin/bash
# Make an ascii art to welcome the user to the script
echo "###############################################################################################################"
echo "Welcome to the CrowdRockers Hyprland Config installation script"
echo "This script will install all the dependencies required and copy the files from garuda-sway-config to ~/.config"
echo "Please make sure you have an active internet connection before running this script"
echo "Press Ctrl+C to exit the script"
echo "Press Enter to continue"
echo "###############################################################################################################"
read

# Get this script directory 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get distro name
distro=$(cat /etc/os-release | grep -w "NAME" | cut -d "=" -f2 | tr -d '"')

# Ask the user if they want to update the system
echo "It is recommended to update your system first. Do you want to update the system? (y/n)"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  # If the distro is Garuda Linux, update the system using update command, else use pacman
  echo "Updating system"
  if [ "$distro" == "Garuda Linux" ]; then
    echo "Detected Garuda Linux, updating system..."
    update
  else
    echo "Not Garuda Linux, updating system using pacman..."
    sudo pacman -Syu --noconfirm
  fi
else
  echo "Skipping system update..."
fi

echo "Installing paru"
# Install paru
sudo pacman -S paru --noconfirm
echo "paru installed successfully"

# Function to check if a package is installed, if not, install it using paru
function install {
  if ! pacman -Qi $1 &> /dev/null; then
    echo "Installing $1..."
    paru -S $1 --noconfirm
  else
    echo "$1 is already installed. Skipping..."
  fi
}

# Add chaotic AUR keys and repository if not added, else skip
echo "Adding chaotic AUR keys and repository"
if ! pacman-key --list-keys chaotic-aur &> /dev/null; then
  echo "Adding chaotic AUR keys and repository"
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 3056513887B78AEB
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
  echo "Chaotic AUR keys added successfully"
else 
  echo "Chaotic AUR keys and repository already added. Skipping..."
fi

# Add chaotic AUR
if ! grep -q "^\[chaotic-aur\]" /etc/pacman.conf; then
  echo "[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
  sudo pacman -Sy
  echo "Chaotic AUR repository added/updated successfully"
fi


# Install dependencies using the install function
# Make an array of all the dependencies (swaylock-effects rofi-lbonn-wayland waybar-git neofetch cava foot hyprland-git mpd mpc sweet-cursor-theme-git ttf-font-awesome nerd-fonts hyprpicker pipewire wireplumber fish)
dependencies=(
     acpi
    blueberry
    bluez
    bluez-utils
    brightnessctl
    btop
    cava-git
    dart-sass
    fish
    foot 
    gnome-bluetooth-3.0
    gpu-screen-recorder
    grimblast
    hyprpicker 
    kitty
    matugen
    micro
    most
    mpc 
    mpd 
    nerd-fonts 
    networkmanager
    oh-my-posh
    pavucontrol
    pipewire 
    rose-pine-cursor
    rose-pine-hyprcursor
    swww
    ttf-font-awesome 
    wireplumber 
    wl-clipboard
    wofi-emoji
    adobe-source-han-sans-cn-fonts
    adobe-source-han-sans-jp-fonts
    adobe-source-han-sans-kr-fonts
    adobe-source-sans-fonts
    adobe-source-serif-fonts
    alacritty
    alsa-firmware
    alsa-utils
    amd-ucode
    appimagelauncher
    appmenu-gtk-module
    appstream-qt5
    arandr
    arch-install-scripts
    arch-update
    ardour
    aria2
    arj
    atril
    audacity
    autotiling
    awesome-terminal-fonts
    azote
    b43-fwcutter
    baobab
    base
    base-devel
    bash-completion
    beautyline
    bibata-cursor-translucent
    bibata-extra-cursor-theme
    bibata-rainbow-cursor-theme
    bind
    bitwarden
    bleachbit
    blender
    blueman
    bluetooth-autoconnect
    bluetooth-support
    bottles
    boxtron
    brave-bin
    breeze
    bridge-utils
    brltty
    broadcom-wl-dkms
    btop
    btrfs-assistant
    btrfs-progs
    bzip2
    calf
    carla
    catfish
    cava
    chaotic-keyring
    chaotic-mirrorlist
    chezmoi
    chiaki
    clapper
    cliphist
    clipman
    clonezilla
    codeblocks
    coreutils
    cpupower
    cryptsetup
    curlftpfs
    darkhttpd
    darktable
    ddrescue
    deluge-gtk
    dex
    dhclient
    dhcpcd
    dialog
    digikam
    discord
    dmenu
    dmidecode
    dmraid
    docker
    docker-compose
    dosfstools
    dotnet-host
    dotnet-runtime
    downgrade
    dracula-gtk-theme-git
    dracula-icons-git
    dracut
    duf
    dunst
    dvgrab
    e2fsprogs
    easyeffects
    ecryptfs-utils
    edid-decode-git
    edk2-shell
    efibootmgr
    eog
    epiphany
    espeakup
    ethtool
    evince
    exfatprogs
    f2fs-tools
    fail2ban
    falkon
    fastfetch
    fastfetch
    fatresize
    feh
    ffmpegthumbnailer
    ffmpegthumbs
    file
    file-roller
    filesystem
    filezilla
    findutils
    firedragon
    firefox
    firefox-ublock-origin
    firejail
    flameshot-git
    flashplugin
    flat-remix-git
    flatpak
    fluent-gtk-theme-git
    font-manager
    foot
    freetype2
    frei0r-plugins
    fsarchiver
    fscrypt
    fsearch
    fuse2fs
    fuzzel
    fwupd
    galculator
    garcon
    gawk
    gcc-libs
    gdb
    geany
    geany-plugins
    gedit
    geekbench
    gestures
    gettext
    gimp
    gitg
    github-cli
    github-desktop
    gitkraken
    gksu
    glava
    glibc
    gmtp
    gnome-disk-utility
    gnome-firmware
    gnome-keyring
    gnome-logs
    gnome-system-monitor
    gnu-netcat
    google-chrome
    gpart
    gparted
    graphite-gtk-theme-git
    greetd
    greetd-regreet
    grep
    grilo-plugins
    grim
    grimblast-git
    grub
    grub-btrfs
    grub-garuda
    grub-theme-garuda
    gsimplecal
    gstreamer-meta
    gtk-engine-murrine
    gtkhash-thunar
    gufw
    gum
    gvfs
    gvfs-afc
    gvfs-dnssd
    gvfs-goa
    gvfs-google
    gvfs-gphoto2
    gvfs-mtp
    gvfs-nfs
    gvfs-onedrive
    gvfs-smb
    gvfs-wsdd
    gzip
    hardinfo2
    hdparm
    heroic-games-launcher-bin
    hexchat
    hplip
    htop
    hunspell-fr
    hw-probe
    hydrogen
    hyperv
    hyprpicker-git
    ifuse
    imv
    inetutils
    inkscape
    input-devices-support
    insync-thunar
    intel-ucode
    inxi
    iproute2
    iptables-nft
    iputils
    irssi
    iwd
    jacktrip
    jfsutils
    jq
    jre8-openjdk
    kanshi
    kate
    kazam
    kdenlive
    keepassxc
    kitty
    konsole
    krita
    krita-plugin-gmic
    kvantum
    kvantum-theme-materia
    kvantum-theme-qogir-git
    languagetool
    laptop-detect
    layan-gtk-theme-git
    ldns
    leafpad
    lftp
    lhasa
    lib32-pipewire-jack
    libdvdcss
    libfido2
    libgsf
    libmythes
    libopenraw
    libreoffice-fresh
    librsvg
    licenses
    linux
    linux-atm
    linux-cachyos-lts
    linux-cachyos-lts-headers
    linux-firmware
    linux-firmware-marvell
    linux-headers
    linux-lts
    linux-lts-headers
    linux-zen
    linux-zen-headers
    livecd-sounds
    lmms
    logrotate
    lolcat
    loupe
    lrzip
    lsb-release
    lsd
    lshw
    lsp-plugins-lv2
    lsscsi
    lvm2
    lxappearance
    lxmusic
    lynx
    lzip
    lzop
    mako
    malcontent
    man-db
    man-pages
    materia-gtk-theme
    mc
    mda.lv2
    mdadm
    meld
    memtest86+
    memtest86+-efi
    meson
    micro
    microsoft-edge-stable-bin
    mission-center
    mixxx
    mkinitcpio-firmware
    mkinitcpio-nfs-utils
    modem-manager-gui
    most
    mousepad
    mousetweaks
    movit
    mpc
    mpd
    mpv-mpris
    mtools
    mtpfs
    mugshot
    muse
    mythes-en
    nano
    nautilus
    navi
    nbd
    ncmpcpp
    ndisc6
    neofetch
    neovim
    net-tools
    network-manager-applet
    networkmanager-support
    newsboat
    nfs-utils
    nilfs-utils
    nitrogen
    nm-connection-editor
    nmap
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    nss-mdns
    ntfs-3g
    ntp
    numlockx
    nvme-cli
    nvtop
    nwg-bar
    nwg-dock
    nwg-drawer
    nwg-launchers
    nwg-look
    nwg-panel
    obs-studio
    octopi
    oh-my-posh-bin
    okular
    open-iscsi
    open-vm-tools
    opencolorio
    opencv
    openrgb
    openshot
    opentimelineio
    opus-tools
    orca
    os-prober-btrfs
    otf-font-awesome
    otf-font-awesome-4
    otf-libertinus
    p7zip
    pace
    pacman
    pacman-contrib
    pacseek
    pamac-aur
    pamixer
    parole
    paru
    pavucontrol
    pciutils
    pdfarranger
    perl-file-mimeinfo
    picom
    pikaur-git
    piper
    pipewire-jack
    pipewire-support
    plank
    plasma-framework5
    plasma5-themes-sweet-full-git
    playerctl
    playonlinux
    plocate
    pokemon-colorscripts-git
    polkit-gnome
    polybar
    power-profiles-daemon
    powerpill
    powertop
    printer-support
    procps-ng
    protontricks-git
    protonup-qt
    psmisc
    pulsemixer
    pv
    python-pyparted
    python-pyquery
    python-ttkbootstrap
    qalculate-gtk
    qbittorrent
    qemu-guest-agent
    qogir-gtk-theme-git
    qpwgraph
    qsynth
    qt5-3d
    qt5-charts
    qt5-connectivity
    qt5-datavis3d
    qt5-doc
    qt5-examples
    qt5-imageformats
    qt5-networkauth
    qt5-quick3d
    qt5-remoteobjects
    qt5-scxml
    qt5-sensors
    qt5-serialport
    qt5-tools
    qt5-virtualkeyboard
    qt5-websockets
    qt5ct
    qt6ct
    qtcreator
    qtractor
    r
    ranger
    rate-mirrors
    rebuild-detector
    redshift
    refind
    reflector-simple
    reiserfsprogs
    retroarch
    ripgrep-all
    ristretto
    rocm-hip-runtime
    rocm-opencl-runtime
    rofi-calc
    rsync
    rtl8821cu-morrownr-dkms-git
    rxvt-unicode-terminfo
    rygel
    samba-support
    sardi-icons
    scanner-support
    scrot
    scummvm
    sdbus-cpp
    sddm
    sdparm
    sed
    sg3_utils
    shadow
    shairport-sync
    shotwell
    simple-scan
    simplescreenrecorder
    slurp
    smartmontools
    smplayer
    smplayer-skins
    smplayer-themes
    snapper-support
    snapper-tools
    snapshot
    sof-firmware
    sox
    spotify
    spotify-launcher
    squashfs-tools
    sshfs
    stow
    strace
    streamlink-twitch-gui-bin
    sublime-text-4
    sudo
    surfn-icons-git
    sushi
    swappy
    sway-git
    swaybg
    swayidle
    swaylock
    swww
    syslinux
    sysstat
    system-config-printer
    systemd
    systemd-sysvcompat
    tar
    tcpdump
    tecla
    terminus-font
    testdisk
    the_silver_searcher
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-shares-plugin
    thunar-vcs-plugin
    thunar-volman
    thunderbird
    tmux
    tokyonight-gtk-theme-git
    totem
    traceroute
    ttf-anonymous-pro
    ttf-bitstream-vera
    ttf-caladea
    ttf-carlito
    ttf-cascadia-code
    ttf-cormorant
    ttf-croscore
    ttf-dejavu
    ttf-droid
    ttf-eurof
    ttf-fantasque-sans-mono
    ttf-fira-mono
    ttf-fira-sans
    ttf-firacode-nerd
    ttf-font-awesome
    ttf-hack
    ttf-ibm-plex
    ttf-inconsolata
    ttf-iosevka-nerd
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    ttf-joypixels
    ttf-lato
    ttf-liberation
    ttf-linux-libertine
    ttf-linux-libertine-g
    ttf-mac-fonts
    ttf-meslo-nerd
    ttf-meslo-nerd-font-powerlevel10k
    ttf-monofur
    ttf-ms-fonts
    ttf-nerd-fonts-symbols
    ttf-nerd-fonts-symbols-mono
    ttf-opensans
    ttf-roboto
    ttf-roboto-mono
    ttf-sourcecodepro-nerd
    ttf-ubuntu-font-family
    udftools
    udiskie
    ueberzug
    ufw
    ugrep
    ulauncher
    unace
    unarchiver
    unarj
    unrar
    unzip
    update-grub
    usbutils
    util-linux
    variety
    ventoy-bin
    vi
    vim
    vim-airline
    vimix-cursors
    vimix-gtk-themes
    vimix-icon-theme
    virtualbox-meta
    visual-studio-code-bin
    vivaldi
    vivaldi-ffmpeg-codecs
    vkbasalt
    vlc
    volumeicon
    vscodium
    waybar-module-pacman-updates-git
    wayland
    wayland-protocols-git
    wayland-utils
    wdisplays
    wf-recorder
    wget
    which
    whois
    wine-installer
    wireless_tools
    wireless-regdb
    wireplumber
    wlogout
    wlr-randr-git
    wlroots
    wlsunset
    wofi
    wpaperd
    wqy-zenhei
    wtype
    wvdial
    xarchiver
    xclip
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    xdg-desktop-portal-xapp
    xdg-user-dirs
    xdg-utils
    xed
    xf86-video-vmware
    xfburn
    xorg-bdftopcf
    xorg-mkfontscale
    xorg-sessreg
    xorg-smproxy
    xorg-x11perf
    xorg-xbacklight
    xorg-xcmsdb
    xorg-xcursorgen
    xorg-xdriinfo
    xorg-xev
    xorg-xgamma
    xorg-xhost
    xorg-xkbevd
    xorg-xkbprint
    xorg-xkbutils
    xorg-xkill
    xorg-xlsatoms
    xorg-xlsclients
    xorg-xpr
    xorg-xrefresh
    xorg-xsetroot
    xorg-xvinfo
    xorg-xwayland
    xorg-xwd
    xorg-xwininfo
    xorg-xwud
    xpadneo-dkms-git
    xpdf
    xreader
    xsel
    xsettingsd
    xss-lock
    xz
    yaru-icon-theme
    yay
    yelp
    yt-dlp
    yt-dlp-drop-in
    zam-plugins-lv2
    zathura
    zip
)

important_dependencies=(
  rofi-wayland 
  hyprland-git 
  waybar
  hyprlock-git
  aylurs-gtk-shell
)

# Highly probable that those packages are already installed, but just in case
conflicting_packages=(
  rofi
  hyprland
)

echo "Installing dependencies"
# Loop through the array and install all the dependencies
for i in "${dependencies[@]}"; do
  install $i
done

curl -fsSL https://bun.sh/install | bash && \
  ln -s $HOME/.bun/bin/bun /usr/local/bin/bun

echo "Dependencies installed successfully"

echo "Uninstalling conflicting packages"
for i in "${conflicting_packages[@]}"; do
  # ask user if they want to uninstall the conflicting packages
  echo "Do you want to uninstall $i? (y/n)"
  read answer
  if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Removing $i..."
    sudo pacman -Rdd $i --noconfirm
  else
    echo "Skipping $i..."
  fi
done
echo "Conflicting packages uninstalled successfully"

echo "Installing important dependencies"
echo "You may be asked to replace some packages. Press y to replace them"
# Loop through the array and install all the dependencies
for i in "${important_dependencies[@]}"; do
  paru -S $i
done
echo "Important Dependencies installed successfully"

# Uninstall wlsunset if installed (yes, i hate it)
echo "Uninstalling wlsunset"
if pacman -Qi wlsunset &> /dev/null; then
  sudo pacman -R wlsunset --noconfirm
fi
echo "wlsunset uninstalled successfully"

# Place the files from garuda-sway-config (where this script is located) inside the .config folder
echo "Copying files from garuda-hyprdots to ~/.config"
# copy but ignore the .git folder, LICENSE, .gitignore and README.md
rsync -av $DIR/* ~/.config --exclude='.git' --exclude='LICENSE' --exclude='.gitignore' --exclude='README.md' 
echo "Files copied successfully"

# Edit some config files
# Adding btop theme
echo "color_theme = $HOME/.config/btop/themes/catppuccin_macchiato.theme" >> $HOME/.config/btop/btop.conf

# Ask if the user wants to reboot the system now or not
echo "Do you want to reboot the system now? (y/n)"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  echo "Installation completed successfully. Rebooting in 5 seconds..."
  # Wait for 2s before rebooting 
  sleep 5
  sudo reboot now
else
  echo "Installation completed successfully. Please reboot your system to apply the changes."
fi

