#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine
#
# This should be idempotent so it can be run multiple times.

echo "Starting bootstrapping"

xcode-select --install

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

PACKAGES=(
    ack
    ant
    autoconf
    automake
    boot2docker
    cmatrix
    docker
    docker-compose
    ffmpeg
    gdbm
    gettext
    gifsicle
    git
    gmp
    graphviz
    heroku
    heroku-node
    htop
    httpie
    hub
    icu4c
    imagemagick
    isl
    jq
    libjpeg
    libmemcached
    libmpc
    lynx
    markdown
    maven
    memcached
    mercurial
    mpfr
    ncurses
    node
    node@8
    npm
    oniguruma
    openssl
    pkg-config
    postgresql
    pypy
    python
    python3
    rabbitmq
    readline
    rename
    sqlite
    ssh-copy-id
    telnet
    terminal-notifier
    the_silver_searcher
    tmux
    tree
    typescript
    vim
    wget
    xmlstarlet
    xz
    yarn
    zsh
    zsh-completions
    zsh-git-prompt
    zsh-syntax-highlighting
)

echo "Installing packages..."
for PACKAGE in ${PACKAGES[@]}; do
    brew install ${PACKAGE}
done

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew install caskroom/cask/brew-cask

CASKS=(
    microsoft-office
    spotify
    colluquy
    dropbox
    firefox
    flux
    google-chrome
    google-drive
    gpgtools
    iterm2
    intellij-idea
    macvim
    sfdx
    skype
    slack
    spectacle
    sourcetree
    sublime-text
    vagrant
    virtualbox
    visual-studio-code
    vlc
    wireshark
)

echo "Installing cask apps..."
for CASK in ${CASKS[@]}; do
    brew cask install ${CASK}
done

echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-inconsolidata
    font-roboto
    font-clear-sans
)
brew cask install ${FONTS[@]}

# MAS_APPS=(
#     409183694
#     1107421413
# )
# echo "Installing Mac App Store apps..."
# mas install ${MAS_APPS[@]}

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    ipython
    virtualenv
    virtualenvwrapper
)
for PYTHON_PACKAGE in ${PYTHON_PACKAGES[@]}; do
    sudo pip install ${PYTHON_PACKAGE}
done

echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    filewatcher
    cocoapods
)
for RUBY_GEM in ${RUBY_GEMS[@]}; do
    sudo gem install ${RUBY_GEM}
done

echo "Installing global npm packages..."
npm install marked -g

echo "Configuring OSX..."

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder > Preferences > Show warning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "Creating folder structure..."
[[ ! -d workspace ]] && mkdir workspace

# TODO Pull in my setup from .zshrc file

echo "Installing powerlevel9k..."
brew tap sambadevi/powerlevel9k
brew install powerlevel9k


# echo "Configuring iTerm2..."
# /usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Normal Font" HackNerdFontComplete-Regular 12' ~/Library/Preferences/com.googlecode.iterm2.plist
# /usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Use Non-ASCII Font" false' ~/Library/Preferences/com.googlecode.iterm2.plist
# /usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Cursor Type" 1' ~/Library/Preferences/com.googlecode.iterm2.plist

echo "Installing vs code extensions..."
CODE_EXTENSIONS = (
    andys8.jest-snippets
    blzjns.vscode-raml
    chuckjonas.apex-pmd
    dbaeumer.vscode-eslint
    donjayamanne.githistory
    DotJoshJohnson.xml
    eamodio.gitlens
    Equinusocio.vsc-community-material-theme
    Equinusocio.vsc-material-theme
    equinusocio.vsc-material-theme-icons
    esbenp.prettier-vscode
    gamunu.vscode-yarn
    Gruntfuggly.todo-tree
    mariusschulz.yarn-lock-syntax
    maty.vscode-mocha-sidebar
    ms-azuretools.vscode-docker
    ms-python.python
    oliversturm.fix-json
    redhat.java
    redhat.vscode-yaml
    salesforce.salesforcedx-vscode
    salesforce.salesforcedx-vscode-apex
    salesforce.salesforcedx-vscode-apex-debugger
    salesforce.salesforcedx-vscode-apex-replay-debugger
    salesforce.salesforcedx-vscode-core
    salesforce.salesforcedx-vscode-lightning
    salesforce.salesforcedx-vscode-lwc
    salesforce.salesforcedx-vscode-visualforce
    shardulm94.trailing-spaces
    VisualStudioExptTeam.vscodeintellicode
    vscjava.vscode-java-debug
    vscjava.vscode-java-dependency
    vscjava.vscode-java-pack
    vscjava.vscode-java-test
    vscjava.vscode-maven
    yzhang.markdown-all-in-one
)
for CODE_EXTENSION in ${CODE_EXTENSIONS[@]}; do
    code --install-extension ${CODE_EXTENSION}
done

mv templates/.zshrc ~/.zshrc
mv templates/.custom_aliases ~/.custom_aliases

echo "Installing/updating oh-my-zsh"
if [[ -d ~/.oh-my-zsh ]]; then
    upgrade_oh_my_zsh
else
    chsh -s /bin/zsh
    "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

echo "Bootstrapping complete"