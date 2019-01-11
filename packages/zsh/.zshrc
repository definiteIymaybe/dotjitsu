#!/usr/bin/env zsh

ulimit -n 10000

# ----------------------------------------------------
# Init Prezto
# ----------------------------------------------------
source "$HOME/.repos/zprezto/init.zsh"

# ----------------------------------------------------
# Tmux
# ----------------------------------------------------
if which tmux 2>&1 >/dev/null; then
  if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
    # echo "Loading tmux..."
    #tmux attach -t hack || tmux new -s hack; exit
  else
    neofetch
  fi
fi


source "${ZDOTDIR:-$HOME}/.env"
source "/usr/local/etc/grc.bashrc"
source "$HOME/.aliases"
source "$DOTJITSU/packages/docker/_docker-aliases"
source ~/.private/.zshrc

# Colors
eval $(gdircolors -b $DOTJITSU/packages/dircolors/dircolors.ansi-dark)


# Fuck
eval $(thefuck --alias --enable-experimental-instant-mode)

# Automatically list directory contents on `cd`.
auto-ls () {
  emulate -L zsh;
  # explicit sexy ls'ing as aliases arent honored in here.
  hash gls >/dev/null 2>&1 && CLICOLOR_FORCE=1 gls -aFh --color --group-directories-first || ls
}

auto-pkg-scripts () {
  emulate -L zsh;
  [ -f "package.json" ] && cs package.json
}

chpwd_functions=( auto-ls auto-pkg-scripts $chpwd_functions )

# Automatically load .envrc files
# https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

# Fasd autocompletion
eval "$(fasd --init auto)"

# export JAVA_HOME="$(/usr/libexec/java_home -v 10)"


# NVM
# =================================================================
# wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh" # This loads nvm
. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install --lts
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc





# Better history
# Credits to https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
# autoload -U up-line-or-beginning-search
# autoload -U down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# bindkey "^[[A" up-line-or-beginning-search # Up
# bindkey "^[[B" down-line-or-beginning-search # Down


#autoload -Uz compinit && compinit -i
# fpath=(/usr/local/share/zsh-completions $fpath)
source $DOTJITSU/packages/fzf/.fzf
