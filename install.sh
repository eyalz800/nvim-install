#!/bin/bash

set -e

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar -xzvf nvim-linux64.tar.gz
    cd nvim-linux64
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
