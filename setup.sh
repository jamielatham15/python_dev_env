#!/bin/bash
set -e

sudo apt -y update && sudo apt -y dist-upgrade

## Python build deps
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt -y install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
 
# Pyenv Setup
curl https://pyenv.run | bash

# Pyenv environment variables
if grep -Fxq 'export PYENV_ROOT="$HOME/.pyenv"' ~/.profile; then
    echo Environment variables already configured, skipping...
else
    sed -i '10 i\\nexport PYENV_ROOT="$HOME/.pyenv"\nexport PATH="$PYENV_ROOT/bin:$PATH"' ~/.profile
    sed -i '13 i\\nexport PIPENV_PYTHON="$PYENV_ROOT/shims/python"\nexport PATH="$PIPENV_PYTHON/bin:$PATH"' ~/.profile
    echo -e '\neval "$(pyenv init --path)"' >> ~/.profile
    echo -e '\neval "$(pyenv init -)"' >> ~/.bashrc
fi
source ~/.profile
source ~/.bashrc

# Python install
pyenv install -l | grep "3.*" -
echo Which version would you like to install globally?:
read VERSION
pyenv install $VERSION
pyenv global $VERSION

# Pipenv install
python -m pip install --upgrade pip
python -m pip install pipenv
echo 'alias pipenv="python -m pipenv"' >> ~/.bashrc
source ~/.bashrc