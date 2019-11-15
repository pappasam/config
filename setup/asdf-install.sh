# After getting ASDF installed, run this script...

set -e

asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 12.13.0
asdf global nodejs 12.13.0
npm install neovim
asdf reshim nodejs

asdf plugin-add php
asdf install php 7.3.11
asdf global php 7.3.11

asdf plugin-add python
asdf install python 3.7.5
asdf install python 3.8.0
asdf global python 3.7.5

asdf plugin-add ruby
asdf install ruby 2.6.5
asdf global ruby 2.6.5

asdf plugin-add rust
asdf install rust nightly
asdf global rust nightly

asdf plugin-add yarn
asdf install yarn 1.19.1
asdf global yarn 1.19.1

asdf plugin-add golang
asdf install golang 1.13.4
asdf global golang 1.13.4
