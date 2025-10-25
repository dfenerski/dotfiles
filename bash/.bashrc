# Aliases
alias vim='nvim'
alias p3='python3'
alias tf='terraform'
alias pdf='evince'
alias files='yazi'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias :q='exit'

# Env aliases
export KUBE_EDITOR='nvim'
export EDITOR='nvim'


# Custom env vars
export NVIMC="$HOME/.config/nvim"

# Functions

# vttoggle() {
    # theme_file="$NVIMC/lua/dfenerski/colorscheme.lua"
    # if grep -q "current_theme = Themes.LIGHT" "$theme_file"; then
    #     sed -i 's/current_theme = Themes.LIGHT/current_theme = Themes.DARK/g' "$theme_file"
    # else
    #     sed -i 's/current_theme = Themes.DARK/current_theme = Themes.LIGHT/g' "$theme_file"
    # fi

    # current=$(gsettings get org.gnome.desktop.interface color-scheme)
    # if [ "$current" = "'default'" ]; then
    #   gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    # else
    #   gsettings set org.gnome.desktop.interface color-scheme 'default'
    # fi

# }

dnd() {
    gsettings set org.gnome.desktop.notifications show-banners $(if [ "$(gsettings get org.gnome.desktop.notifications show-banners)" = "true" ]; then echo "false"; else echo "true"; fi)
}

no_sleep() {
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
}

yes_sleep() {
    sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
}

spawn_edge() {
    /opt/microsoft/msedge/msedge -inprivate
}

spawn_chromium() {
    chromium -incognito
}

