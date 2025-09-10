# Project Earth 
**Version: `v155.4`** \
A script to install your apps, from a configuration housed in a `.toml` file - for simple, unattended and rapid setups. 

### Usage
1. `bash <(curl -s "https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/downloader.sh")`
2. `cd earth`
3. `./earth.sh`

_Toml configuration_
```toml
[pacman]
# fill with package names
install = ['git' ,'cava']
[flatpak]
# fill with package IDs
install = ['app.zen_browser.zen']
[git]
# fill with urls to repo 
clone = ['https://github.com/WeirdTreeThing/chromebook-linux-audio.git']
# and specify which location to download to
location = ['./cache/git']
[wget]
# fill with url to a file
file = ['https://raw.githubusercontent.com/4urora3night/dotfiles/refs/heads/main/pac.toml']
# and specify which location to download to
location = ['./cache/wget']
```

The TOML file can be placed in the level above and all levels below the the Project Earth folder. For example:
```
📁 Home
∟ 📄 {Your TOML File}.toml
∟ 📁 earth
  ∟ 📄 {Another place your TOML File can live}.toml
  ∟ 📁 lib
    ∟ 📄 {Here too can your TOML File exist}.toml
  ∟ 📄 earth.sh
```
Hidden toml files are allowed.



### Changelogs 
Available in  [changelogs.md](https://github.com/4urora3night/earth/blob/tera/changelog.md)

---
### *Thanks to:*
- [*Gum*](https://github.com/charmbracelet/gum) \
	➜ All the eyecandy. 👀
- ML4W's scripts \
  ➜ Inspiration. ⭐
	
##### Made by `4urora3night` for a better quality of life 🌟
