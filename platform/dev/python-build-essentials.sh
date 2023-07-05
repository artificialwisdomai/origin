#!/bin/bash
# Install python and build essentials and essential libraries
sudo apt-get install -y python3-pip python3-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev liblzma-dev libsqlite3-dev libreadline-dev libbz2-dev

# Install pyenv to manage multiple python versions and environments
curl https://pyenv.run | bash

# Add pyenv to .profile and .bashrc

cat >> $HOME/.profile <<EOF
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF

cat >> $HOME/.bashrc <<EOF
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF

