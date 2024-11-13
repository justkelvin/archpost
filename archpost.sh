#!/usr/bin/env bash

# archpost - Modular Arch Linux Post-Installation System
# This script provides a modular approach to configuring a fresh Arch Linux installation

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration directory
CONFIG_DIR="$HOME/.config/archpost"
LOG_FILE="$CONFIG_DIR/install.log"

# Module definitions
declare -A MODULES=(
    ["desktop"]="Desktop Environment Installation"
    ["nvidia"]="NVIDIA Graphics Drivers"
    ["audio"]="Audio Configuration"
    ["bluetooth"]="Bluetooth Setup"
    ["network"]="Network Management"
    ["dev"]="Development Tools"
    ["virtualization"]="Virtualization Support"
    ["laptop"]="Laptop-specific Tools"
    ["gaming"]="Gaming Setup"
    ["multimedia"]="Multimedia Tools"
)

# Function to create configuration directory
setup_config_dir() {
    mkdir -p "$CONFIG_DIR"
    touch "$LOG_FILE"
}

# Function to log messages
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run as root${NC}"
        exit 1
    fi
}

# Function to update system
update_system() {
    echo -e "\n${BLUE}=== Updating System ===${NC}"
    pacman -Syu --noconfirm
    log_message "System updated"
}

# Module: Desktop Environment
install_desktop() {
    echo -e "\n${BLUE}=== Desktop Environment Installation ===${NC}"
    local de_options=("xfce4" "kde" "gnome" "i3-wm" "quit")
    
    select de in "${de_options[@]}"; do
        case $de in
            "xfce4")
                pacman -S --noconfirm xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
                systemctl enable lightdm
                log_message "Installed XFCE4 desktop environment"
                break
                ;;
            "kde")
                pacman -S --noconfirm plasma kde-applications sddm
                systemctl enable sddm
                log_message "Installed KDE Plasma desktop environment"
                break
                ;;
            "gnome")
                pacman -S --noconfirm gnome gnome-extra gdm
                systemctl enable gdm
                log_message "Installed GNOME desktop environment"
                break
                ;;
            "i3-wm")
                pacman -S --noconfirm i3-wm i3status i3blocks dmenu rxvt-unicode lightdm lightdm-gtk-greeter
                systemctl enable lightdm
                log_message "Installed i3 window manager"
                break
                ;;
            "quit")
                return
                ;;
        esac
    done
}

# Module: NVIDIA Graphics
install_nvidia() {
    echo -e "\n${BLUE}=== NVIDIA Graphics Installation ===${NC}"
    local nvidia_packages=(
        "nvidia"
        "nvidia-settings"
        "nvidia-utils"
        "lib32-nvidia-utils" # For 32-bit support
    )
    
    pacman -S --noconfirm "${nvidia_packages[@]}"
    
    # Create basic Xorg configuration
    mkdir -p /etc/X11/xorg.conf.d/
    cat > /etc/X11/xorg.conf.d/20-nvidia.conf << EOF
Section "Device"
    Identifier "Nvidia Card"
    Driver "nvidia"
    Option "NoLogo" "true"
EndSection
EOF
    
    log_message "Installed NVIDIA drivers and configured Xorg"
}

# Module: Audio Configuration
setup_audio() {
    echo -e "\n${BLUE}=== Audio Configuration ===${NC}"
    local audio_packages=(
        "pulseaudio"
        "pulseaudio-alsa"
        "alsa-utils"
        "pavucontrol"
    )
    
    pacman -S --noconfirm "${audio_packages[@]}"
    systemctl --user enable pulseaudio
    log_message "Configured audio system"
}

# Module: Development Tools
install_dev_tools() {
    echo -e "\n${BLUE}=== Development Tools Installation ===${NC}"
    local dev_packages=(
        "base-devel"
        "git"
        "vim"
        "neovim"
        "visual-studio-code-bin"
        "docker"
        "docker-compose"
        "python"
        "python-pip"
        "nodejs"
        "npm"
    )
    
    # Install yay AUR helper
    if ! command -v yay &> /dev/null; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi
    
    # Install packages
    yay -S --noconfirm "${dev_packages[@]}"
    
    # Enable Docker service
    systemctl enable docker
    usermod -aG docker "$SUDO_USER"
    
    log_message "Installed development tools"
}

# Module: Gaming Setup
setup_gaming() {
    echo -e "\n${BLUE}=== Gaming Setup ===${NC}"
    local gaming_packages=(
        "steam"
        "lutris"
        "wine"
        "wine-gecko"
        "wine-mono"
        "gamemode"
        "lib32-gamemode"
    )
    
    # Enable multilib if not already enabled
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
        pacman -Sy
    fi
    
    pacman -S --noconfirm "${gaming_packages[@]}"
    log_message "Installed gaming packages"
}

# Function to display menu and handle selection
show_menu() {
    local selected_modules=()
    
    while true; do
        echo -e "\n${BLUE}=== Arch Linux Post-Installation Menu ===${NC}"
        echo "Select modules to install (multiple selections allowed):"
        
        local i=1
        for module in "${!MODULES[@]}"; do
            local status="[ ]"
            if [[ " ${selected_modules[@]} " =~ " ${module} " ]]; then
                status="[x]"
            fi
            echo "$i) $status ${MODULES[$module]}"
            ((i++))
        done
        
        echo "A) Apply selected modules"
        echo "Q) Quit"
        
        read -rp "Enter selection: " choice
        
        case $choice in
            [1-9]|10)
                local module_name=(${!MODULES[@]})[$((choice-1))]
                if [[ " ${selected_modules[@]} " =~ " ${module_name} " ]]; then
                    selected_modules=("${selected_modules[@]/$module_name}")
                else
                    selected_modules+=("$module_name")
                fi
                ;;
            [Aa])
                for module in "${selected_modules[@]}"; do
                    case $module in
                        "desktop") install_desktop ;;
                        "nvidia") install_nvidia ;;
                        "audio") setup_audio ;;
                        "dev") install_dev_tools ;;
                        "gaming") setup_gaming ;;
                    esac
                done
                break
                ;;
            [Qq])
                exit 0
                ;;
        esac
    done
}

# Main execution
main() {
    echo -e "${BLUE}=== Arch Linux Post-Installation System ===${NC}"
    check_root
    setup_config_dir
    update_system
    show_menu
    
    echo -e "\n${GREEN}Post-installation completed successfully!${NC}"
    echo "Check $LOG_FILE for installation details"
}

# Execute main function
main
