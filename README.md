## Linux

```bash
ln -s $(pwd)/.bash_aliases ~/.bash_aliases
```

## Mac

```bash
ln -s $(pwd)/.mac_aliases ~/.mac_aliases
echo "source $(pwd)/.mac_aliases" >> ~/.zshrc
echo "source $(pwd)/.bash_aliases" >> ~/.zshrc
```