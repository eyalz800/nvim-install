#!/bin/bash

set -e

NEOVIM_VERSION="v0.11.4"
DOWNLOAD_URL=""

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y curl
    arch=$(uname -m)

    if [[ "$arch" == "x86_64" ]]; then
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-linux-x86_64.tar.gz"
    elif [[ "$arch" == "aarch64" ]]; then
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-linux-arm64.tar.gz"
    else
        echo "Unsupported architecture: $arch"
        exit 1
    fi

    curl -fLo nvim.tar.gz "$DOWNLOAD_URL"
    tar -xzvf nvim.tar.gz
    rm nvim.tar.gz
    cd nvim*

    sudo rm -rf /usr/local/share/nvim
    sudo rm -rf /usr/local/lib/nvim
    sudo rm -rf /usr/local/bin/nvim

    sudo cp -R share/nvim /usr/local/share
    sudo cp -R lib/nvim /usr/local/lib
    sudo cp -R bin/nvim /usr/local/bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v curl >/dev/null 2>&1; then
        brew install curl
    fi

    arch=$(uname -m)

    if [[ "$arch" == "x86_64" ]]; then
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-macos-x86_64.tar.gz"
    elif [[ "$arch" == "arm64" ]]; then
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-macos-arm64.tar.gz"
    else
        echo "Unsupported architecture: $arch"
        exit 1
    fi

    curl -fLo nvim.tar.gz "$DOWNLOAD_URL"
    tar -xzvf nvim.tar.gz
    rm nvim.tar.gz

    # Find the extracted directory name, e.g., nvim-osx64 or nvim-macos-arm64
    EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "nvim-*" -print -quit)

    if [[ -z "$EXTRACTED_DIR" ]]; then
        exit 1
    fi

    mkdir -p "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.local/lib"

    # Move nvim executable
    mv "${EXTRACTED_DIR}/bin/nvim" "$HOME/.local/bin/nvim"

    # Copy share and lib directories (copy the 'nvim' sub-directory from share/lib)
    cp -R "${EXTRACTED_DIR}/share/nvim" "$HOME/.local/share/"
    cp -R "${EXTRACTED_DIR}/lib/nvim" "$HOME/.local/lib/"

    # Clean up extracted directory
    rm -rf "${EXTRACTED_DIR}"

    chmod +x "$HOME/.local/bin/nvim"
else
    echo "Unsupported OS"
    exit 1
fi

mkdir -p ~/.config
mv ~/.config/nvim ~/.config/nvim.old 2>/dev/null || true
git clone https://github.com/eyalz800/nvim.lua ~/.config/nvim
