# Copy and paste using terminal
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Open tmux with proper color schemes enabled
alias tmux='tmux -2'

# View public IP address
alias publicip='wget -qO - http://ipecho.net/plain ; echo'

# Sets the Mail Environment Variable
MAIL=/var/spool/mail/sroeca && export MAIL
