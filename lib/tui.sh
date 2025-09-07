#!/bin/bash
# by 4urora3night

title() {
  gum style \
    --foreground 4 --border-foreground 2 --border double \
    --align center --width "${text_box_size}" --margin "0 1" --padding "2 0" \
    "███████╗ █████╗ ██████╗ ████████╗██╗  ██╗
██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██║  ██║
█████╗  ███████║██████╔╝   ██║   ███████║
██╔══╝  ██╔══██║██╔══██╗   ██║   ██╔══██║
███████╗██║  ██║██║  ██║   ██║   ██║  ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
                                         "
}

text_box() {
  local text
  text="$(echo -e "$1")"
  gum style \
    --foreground 7 --border-foreground 4 --border normal \
    --align left --width "${text_box_size}" --margin "0 1" --padding "1 1" \
    "${text}"
}

text_box_confirm() {
  local text
  text="$(echo -e "$1")"
  gum style \
    --foreground 7 --border-foreground 1 --border normal \
    --align left --width "${text_box_size}" --margin "0 1" --padding "1 1" \
    "${text}"
}

text_confirm() {
  gum confirm \
    " $1" --prompt.foreground 7 --selected.background 2
}

text_error() {
  local text
  text="$(echo -e "$1")"
  gum style \
    --foreground 1 --border-foreground 1 --border normal \
    --align center --width ${text_box_size} --margin "0 1" \
    "${text}"
}

text_log() {
  local text
  text="$(echo -e "$1")"
  gum style \
    --foreground 3 \
    --align center --width ${text_box_size} --margin "0 1" \
    "${text}"
}

fzf_app_search() {
  fzf --style full \
    --border rounded \
    --margin 0,1 \
    --height 20% \
    --border-label ' Application Finder ' --input-label ' Input ' --header-label ' File Type '
}

fzf_toml_search() {
  fzf --style full \
    --border rounded \
    --margin 0,1 \
    --height 20% \
    --border-label ' Toml Finder ' --input-label ' Input ' --header-label ' File Type ' \
    --preview 'bat --style=numbers --color=always {}'
}
