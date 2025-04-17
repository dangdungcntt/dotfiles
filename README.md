## Linux

```bash
ln -s $(pwd)/.bash_aliases ~/.bash_aliases
ln -s $(pwd)/.gitconfig ~/.gitconfig
```

Install `zoxide`

```bash
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

## Mac

```bash
echo "source $(pwd)/.mac_aliases" >> ~/.zshrc
echo "source $(pwd)/.bash_aliases" >> ~/.zshrc
ln -s $(pwd)/.gitconfig ~/.gitconfig
```

## Custom .gitconfig

```bash
ln -s $(pwd)/.gitconfig-custom ~/.gitconfig-custom
```

## Laravel Tinker in $HOME folder

```bash
cd $HOME
composer create-project laravel/laravel tinkerhome
ln -s $HOME/tinkerhome/artisan ~/artisan
```
