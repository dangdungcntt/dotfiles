## Linux

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

## Laravel Tinker in $HOME folder

```bash
cd $HOME
composer create-project laravel/laravel tinkerhome
ln -s $HOME/tinkerhome/artisan ~/artisan
```