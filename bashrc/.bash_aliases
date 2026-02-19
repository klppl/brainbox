# ------------------------------------------------------------------------------
# SETUP
# ------------------------------------------------------------------------------
# sudo nano ~/.bash_aliases
# source ~/.bashrc

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

# Basic Operations
alias gst="git status"
alias ga='git add .'
alias gc='git commit -m'
alias gcan='git commit --amend --no-edit' # Add changes to last commit without changing message
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'

# Branching & Checkout
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'

# Visualization & Logs
alias glo="git log --oneline --graph --decorate" # A beautiful, readable tree log
alias glog="git log --all --graph --decorate --oneline" # Log for all branches

# Git Worktree (Multi-tasking)
alias gwt="git worktree"
alias gwtl="git worktree list"
alias gwta="git worktree add"
alias gwtrm="git worktree remove"

# The Nuclear Option
alias gitnuke="git reset --hard HEAD && git clean -fd"
alias guncommit="git reset --soft HEAD~1" # Undo last commit but keep changes staged

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

function git_dashboard() {
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




