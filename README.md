# Project Earth
##### by `4urora3night`
##### Version: `153` — *[Beta]*
A script to install your apps, all housed in a `.toml` file - for rapid and automated arch linux setups. \
Initially inspired by the ML4W options script.

### Requirements
- Arch linux system
- Active WiFi connection

### Usage
You can download the script with:
Clone the repo:

```bash
bash <(curl -s "https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/downloader.sh")
cd earth
./earth.sh
```


To use the App installer feature, you need a {Name}.toml file containing AUR/pacman and/or flatpak packages.
Example config available at test.toml, inc. table names for wget and git

*Toml*:
```toml
[pacman] 
#Table name = Compulsory
install = ['cava', 'fzf'] 
# List = Fill with package names
[flatpak]
install = ['md.obsidian.Obsidian', 'app.zen_browser.zen']
```

The TOML file can be placed in the level above and _all_ levels below the the Project Earth folder.
For example:
```
📁 Home
∟ 📄 {Your TOML File}.toml
∟ 📁 earth
  ∟ 📄 {Another place your TOML File can live}.toml
  ∟ 📁 lib
    ∟ 📄 {Here also can your TOML File stay}.toml
  ∟ 📄 earth.sh
```
Hidden toml files are allowed.

#### Changelog

> 🗓️ 27 Jul 2025
> - Added a more features.
>    - wget
>    - git clone

> 🗓️ 21 Jul 2025
> - Support for ports to other distro is now possible.


older logs can be found in changelog.md

### Notes

When running the script, if a error occurs the script will exit so logs are visible. \
huh... its been a interesting first project wriiten in bash, but for now I will work on another project so I may futher improve my developer skills...
👋 The next update won't be until a while.

---
### *Thanks to:*
- [*Gum*](https://github.com/charmbracelet/gum) \
	➜ All the eyecandy.
- *ML4W options script* \
	➜  For inspiration and borrowed code.
	
