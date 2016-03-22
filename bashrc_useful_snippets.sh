# File contains useful code for ~/.bashrc files

#######################################################################
# Copy and paste using terminal
#######################################################################
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

#######################################################################
# Open tmux with proper color schemes enabled
#######################################################################
alias tmux='tmux -2'

#######################################################################
# View public IP address
#######################################################################
alias publicip='wget -qO - http://ipecho.net/plain ; echo'

#######################################################################
# Set command to include git branch in my prompt
#######################################################################
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
BOLD_GREEN="\[\033[0;32m\]\e[1m"
BOLD_LIGHT_BLUE="\[\033[0;94m\]\e[1m"
NO_COLOR="\[\033[0m\]"

PS1_BEGINNING="$BOLD_GREEN\u@\h$BOLD_LIGHT_BLUE:\w"
PS1_ENDING="$YELLOW\$(parse_git_branch)$BOLD_LIGHT_BLUE \$$NO_COLOR "
PS1="${PS1_BEGINNING}${PS1_ENDING}"
