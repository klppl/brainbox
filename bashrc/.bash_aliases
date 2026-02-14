# ------------------------------------------------------------------------------
# REMOTE CONNECTIONS
# ------------------------------------------------------------------------------
alias ssh_unraid="ssh root@192.168.50.5"
alias chatten="ssh user@host -t 'tmux attach-session -t weechat'"

# ------------------------------------------------------------------------------
# NAVIGATION & FILE LISTING
# ------------------------------------------------------------------------------
alias ls="ls -Fh --color=auto"
alias la="ls -lAh"
alias dl="cd ~/Downloads"  # Fixed typo and used standard path
alias plusx="chmod +x"

# Clean up temporary backup files (ending in ~)
alias cleanfs='find ~/ -type f -name "*~" -delete'

# ------------------------------------------------------------------------------
# SYSTEM INFO & UTILS
# ------------------------------------------------------------------------------
alias vädret="curl wttr.in/Orebro?lang=sv"
alias myip="curl ident.me && echo" # Separated from whoami to avoid recursion
alias nuke="killall5"              # Use with caution!

# ------------------------------------------------------------------------------
# PACKAGE MANAGEMENT (APT)
# ------------------------------------------------------------------------------
# Using 'apt' instead of 'apt-get' for better interactive output
alias app="sudo apt"
alias app-install="sudo apt install"
alias app-remove="sudo apt remove"
alias app-search="apt-cache --names-only search"
alias app-search-all="apt-cache search"
alias app-info="apt-cache show"
alias app-edit="sudo edit /etc/apt/sources.list"
alias app-update="sudo apt update && sudo apt upgrade -y"

# ------------------------------------------------------------------------------
# GIT SHORTCUTS
# ------------------------------------------------------------------------------
alias gst="git status"
alias gitnuke="git reset --hard HEAD && git clean -fd"
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gcb='git checkout -b' # Create and switch to new branch

# ------------------------------------------------------------------------------
# SHELL CONFIGURATION
# ------------------------------------------------------------------------------
# Removed 'sudo' because you own your home directory files
alias bashedit="nano ~/.bashrc"
alias bashrefresh="source ~/.bashrc"

# ------------------------------------------------------------------------------
# FUNCTIONS
# ------------------------------------------------------------------------------
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
