## Linux

### Dependencies

```bash
# Install deps
sudo apt install -y vim curl bat
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# --- Link batcat to ~/.local/bin/bat if needed ---
mkdir -p "$HOME/.local/bin"
if command -v batcat &>/dev/null; then
    if [ ! -f "$HOME/.local/bin/bat" ]; then
        ln -s "$(command -v batcat)" "$HOME/.local/bin/bat"
        echo "Linked batcat to ~/.local/bin/bat"
    else
        echo "~/.local/bin/bat already exists, skipping symlink"
    fi
else
    echo "batcat not found — something went wrong with apt install"
    exit 1
fi

# Add ~/.local/bin to PATH if not already present
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
    echo "Added ~/.local/bin to PATH"
fi

# Add zoxide init command to .bashrc if not already present
if ! grep -q 'eval "$(zoxide init bash)"' ~/.bashrc; then
    echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
    echo "Added zoxide init to .bashrc"
else
    echo "zoxide init already present in .bashrc"
fi
```

### Create symlink for configs

```bash
ln -s $(pwd)/.bash_aliases ~/.bash_aliases
ln -s $(pwd)/.gitconfig ~/.gitconfig
```

## Mac

```bash
echo "source $(pwd)/.mac_aliases" >> ~/.zshrc
echo "source $(pwd)/.bash_aliases" >> ~/.zshrc
ln -s $(pwd)/.gitconfig ~/.gitconfig
```

## Custom .gitconfig

Create new gitconfig file and update `.gitconfig` 
