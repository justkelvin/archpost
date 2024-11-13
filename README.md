# 🎯 archpost

> A modular post-installation script system for Arch Linux that lets users customize their setup with ease.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Support-1793D1?logo=arch-linux&logoColor=white)](https://archlinux.org/)

## Overview

`archpost` is a flexible post-installation script for Arch Linux that allows users to selectively configure different aspects of their system. It provides a modular approach to system configuration, letting users choose exactly what they want to install and configure.

## Features

### Core Modules

- 🖥️ **Desktop Environments**
  - XFCE4
  - KDE Plasma
  - GNOME
  - i3-wm

- 🎮 **Graphics & Gaming**
  - NVIDIA drivers setup
  - Steam, Lutris, Wine
  - GameMode optimization

- 🔊 **Audio Configuration**
  - PulseAudio setup
  - ALSA utilities
  - Audio controls

- 💻 **Development Environment**
  - Essential build tools
  - Popular IDEs
  - Docker setup
  - Programming languages

### Key Features

- ✨ Interactive menu system
- 📝 Detailed logging
- 🔄 Modular architecture
- ⚡ Easy to extend
- 🛡️ Safe installation practices

## Installation

```bash
# Clone the repository
git clone https://github.com/justkelvin/archpost.git

# Enter directory
cd archpost

# Make executable
chmod +x archpost.sh

# Run the script
sudo ./archpost.sh
```

## Usage

1. Run the script with root privileges
2. Select desired modules from the menu
3. Confirm selections
4. Wait for installation to complete

```bash
sudo ./archpost.sh
```

## Module Details

### Desktop Environment
- Choice of popular desktop environments
- Automatic display manager configuration
- Essential desktop utilities

### NVIDIA Graphics
- Driver installation
- X.org configuration
- 32-bit support
- Settings utility

### Development Tools
- Base development packages
- Version control systems
- Popular IDEs and editors
- Container support
- Common programming languages

### Gaming Setup
- Steam and Lutris
- Wine configuration
- Performance optimization
- Controller support

## Configuration

The script creates its configuration directory at `~/.config/archpost/` with:
- Installation logs
- Module configurations
- System preferences

## Adding New Modules

1. Create a new function in the script:
```bash
install_new_module() {
    echo -e "\n${BLUE}=== New Module Installation ===${NC}"
    # Module implementation
    log_message "New module installed"
}
```

2. Add to the MODULES array:
```bash
MODULES["new_module"]="New Module Description"
```

3. Add to the menu handler in `show_menu()`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Future Plans

- [ ] Additional desktop environments
- [ ] More development tool options
- [ ] Backup and restore functionality
- [ ] Network configuration options
- [ ] Security hardening options
- [ ] Automated testing
- [ ] Configuration profiles

## Dependencies

- Base Arch Linux installation
- Root privileges
- Internet connection
- Basic system utilities

## Support

If you encounter any issues or have suggestions:
1. Check the [Issues](https://github.com/justkelvin/archpost/issues) page
2. Create a new issue if needed
3. Provide system details and logs

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the Arch Linux community
- Built with the Arch Way in mind
- Thanks to all contributors
