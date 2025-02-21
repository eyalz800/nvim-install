#!/bin/bash

set -e

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y curl
    arch=$(uname -m)

    if [[ "$arch" == "x86_64" ]]; then
        curl -fLo nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz
    elif [[ "$arch" == "aarch64" ]]; then
        curl -fLo nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-arm64.tar.gz
    fi

    tar -xzvf nvim.tar.gz
    rm nvim.tar.gz
    cd nvim*
    sudo cp -R share/nvim /usr/share
    sudo cp -R lib/nvim /lib
    sudo cp -R bin/nvim /bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install nvim
else
    echo "Unsupported OS"
    exit 1
fi

mkdir -p ~/.config
mv ~/.config/nvim ~/.config/nvim.old 2>/dev/null || true
git clone https://github.com/eyalz800/nvim.lua ~/.config/nvim
