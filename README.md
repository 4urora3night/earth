# Project Earth 
**Version: `v155.3`** \
A script to install your apps, from a configuration housed in a `.toml` file - for simple, unattended and rapid setups. 

### Usage
1. `bash <(curl -s "https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/downloader.sh")`
2. `cd earth`
3. `./earth.sh`
_Toml configuration_


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
	
##### Made by `4urora3night` for a better quality of life 🌟
