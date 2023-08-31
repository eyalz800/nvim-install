#!/bin/bash

set -e

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract
    sudo mv ./squashfs-root /usr/lib/nvim
    sudo ln -s /usr/lib/nvim/AppRun /usr/bin/nvim
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install nvim
else
    echo "Unsupported OS"
    exit 1
fi

mkdir -p ~/.config
mv ~/.config/nvim ~/.config/nvim.old 2>/dev/null || true
git clone https://github.com/eyalz800/nvim.lua ~/.config/nvim
