# ------------------------------------------------------------------------------
# SETUP
# ------------------------------------------------------------------------------
# nano ~/.bash_aliases
# source ~/.bashrc

# Only run the interactive bits when we're actually in an interactive shell.
# Protects scripts, cron, and `ssh host 'command'` from our cd-hook noise.
[[ $- != *i* ]] && return 0

# ------------------------------------------------------------------------------
# HISTORY
# ------------------------------------------------------------------------------
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# ------------------------------------------------------------------------------
# REMOTE CONNECTIONS
# ------------------------------------------------------------------------------
alias ssh_unraid="ssh root@192.168.50.5"

# ------------------------------------------------------------------------------
# AI / DEV TOOLS
# ------------------------------------------------------------------------------
alias clauded="claude --dangerously-skip-permissions"

# ------------------------------------------------------------------------------
# NAVIGATION & FILE LISTING
# ------------------------------------------------------------------------------
alias ls="ls -Fh --color=auto"
alias la="ls -lAh"
alias dl="cd ~/Downloads"
alias plusx="chmod +x"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Safety nets — annoying for two days, invisible after that, life-saving one day.
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Clean up editor backup files, but skip hidden dirs so we don't nuke ~/.config etc.
alias cleanfs='find ~/ -type f -name "*~" -not -path "*/.*" -delete'

mkcd() { mkdir -p "$1" && cd "$1"; }

# ------------------------------------------------------------------------------
# DISK USAGE
# ------------------------------------------------------------------------------
alias du1="du -h --max-depth=1 | sort -hr"
alias duh="du -sh * 2>/dev/null | sort -hr"

# ------------------------------------------------------------------------------
# SYSTEM INFO & UTILS
# ------------------------------------------------------------------------------
alias vädret="curl -m 5 wttr.in/Orebro?lang=sv"
alias myip="echo 'Public:'; curl -s ident.me; echo; echo 'Local:'; hostname -I"

# ------------------------------------------------------------------------------
# SYSTEMD
# ------------------------------------------------------------------------------
alias sctl="sudo systemctl"
alias jctl="sudo journalctl -fu"   # usage: jctl nginx

# ------------------------------------------------------------------------------
# DOCKER
# ------------------------------------------------------------------------------
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"

# ------------------------------------------------------------------------------
# PACKAGE MANAGEMENT (APT)
# ------------------------------------------------------------------------------
alias app="sudo apt"
alias app-install="sudo apt install"
alias app-remove="sudo apt remove"
alias app-search="apt-cache --names-only search"
alias app-search-all="apt-cache search"
alias app-info="apt-cache show"
alias app-edit="sudo edit /etc/apt/sources.list"
alias app-update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"

# ------------------------------------------------------------------------------
# GIT SHORTCUTS
# ------------------------------------------------------------------------------

# Basic Operations
alias gst="git status"
alias ga='git add'                         # no implicit '.', pass paths explicitly
alias gaa='git add .'                      # the "stage everything" shortcut
alias gc='git commit -m'
alias gcan='git commit --amend --no-edit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gfa='git fetch --all --prune'

# Branching & Checkout
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout main 2>/dev/null || git checkout master'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'

# Stash
alias gsta='git stash'
alias gstp='git stash pop'

# Visualization & Logs
alias glo="git log --oneline --graph --decorate"
alias glog="git log --all --graph --decorate --oneline"

# Git Worktree
alias gwt="git worktree"
alias gwtl="git worktree list"
alias gwta="git worktree add"
alias gwtrm="git worktree remove"

# The Nuclear Option
alias gitnuke="git reset --hard HEAD && git clean -fd"
alias guncommit="git reset --soft HEAD~1"

# ------------------------------------------------------------------------------
# SHELL CONFIGURATION
# ------------------------------------------------------------------------------
alias bashedit="nano ~/.bashrc"
alias bashrefresh="source ~/.bashrc"

# ------------------------------------------------------------------------------
# FUNCTIONS
# ------------------------------------------------------------------------------
extract () {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"        ;;
      *.tar.gz)    tar xzf "$1"        ;;
      *.tar.xz)    tar xJf "$1"        ;;
      *.tar.zst)   tar --zstd -xf "$1" ;;
      *.bz2)       bunzip2 "$1"        ;;
      *.rar)       unrar e "$1"        ;;
      *.gz)        gunzip "$1"         ;;
      *.tar)       tar xf "$1"         ;;
      *.tbz2)      tar xjf "$1"        ;;
      *.tgz)       tar xzf "$1"        ;;
      *.xz)        unxz "$1"           ;;
      *.zst)       unzstd "$1"         ;;
      *.zip)       unzip "$1"          ;;
      *.Z)         uncompress "$1"     ;;
      *.7z)        7z x "$1"           ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

httpserver() {
    local port="${1:-8000}"
    echo "Starting server on port $port..."
    if command -v python3 &>/dev/null; then
        python3 -m http.server "$port"
    elif command -v python &>/dev/null; then
        python -m SimpleHTTPServer "$port"
    else
        echo "Error: Python is not installed."
        return 1
    fi
}

git_dashboard() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo -e "\n\033[1;34m--- GIT DASHBOARD ---\033[0m"

        echo -en "\033[0;32mOn Branch: \033[0m"
        git branch --show-current

        if git rev-parse HEAD > /dev/null 2>&1; then
            echo -en "\033[0;36mLast Commit: \033[0m"
            git log -1 --format="%C(yellow)%h %C(reset)%s %C(dim)(%cr)%C(reset)"
        fi

        local wt_count=$(git worktree list | wc -l)
        if [ "$wt_count" -gt 1 ]; then
            echo -e "\n\033[0;33mActive Worktrees:\033[0m"
            git worktree list | awk '{print "  -> " $0}'
        fi

        local status_output=$(git status -s)
        if [ -z "$status_output" ]; then
            echo -e "\n\033[0;32mStatus: Working tree clean\033[0m"
        else
            echo -e "\n\033[0;33mStatus Summary:\033[0m"
            echo "$status_output"
        fi

        echo -e "\033[1;34m----------------------\033[0m"
    fi
}

cd() {
    builtin cd "$@" && git_dashboard
}

git_dashboard
