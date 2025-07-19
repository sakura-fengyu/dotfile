# My config

# mac press and hold 
```
defaults write -g ApplePressAndHoldEnabled -bool false
```

# Brew packages

## install brew using USTC mirro
`
/bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"
`

```
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api" 
```



# install brew
`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`


# install brew packages

```
brew install stow git neovim yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide bat lsd resvg imagemagick starship
brew install rust fastfetch luarocks deno npm golang tmux tree-sitter fastfetch lazygit alacritty tmux macmon
brew install font-jetbrains-mono-nerd-font font-jetbrains-mono-nerd-font
``````

`brew install orbstack`


`starship preset tokyo-night -o ~/.config/starship.toml`
	
```
ssh-keygen -t rsa
ssh -T git@github.com
```
