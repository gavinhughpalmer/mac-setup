#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine
#
# This should be idempotent so it can be run multiple times.

echo "Starting bootstrapping"

# TODO Set so the password can be remembered in all commands
xcode-select --install

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Can list using the command `brew list --formula`
PACKAGES=(
    ack
    ant
    aom
    autoconf
    automake
    cairo
    circleci
    cmatrix
    curl
    docker
    docker-compose
    docker-machine
    erlang
    ffmpeg
    flac
    fontconfig
    freetype
    frei0r
    fribidi
    gd
    gdbm
    gettext
    giflib
    gifsicle
    git
    glib
    gmp
    gnutls
    graphite2
    graphviz
    gts
    harfbuzz
    htop
    httpie
    hub
    icu4c
    ilmbase
    imagemagick
    isl
    jasper
    jpeg
    jq
    krb5
    lame
    leptonica
    libass
    libbluray
    libde265
    libevent
    libffi
    libheif
    libidn2
    libmemcached
    libmpc
    libogg
    libomp
    libpng
    libsamplerate
    libsndfile
    libsoxr
    libtasn1
    libtiff
    libtool
    libunistring
    libvidstab
    libvorbis
    libvpx
    libyaml
    little-cms2
    lua
    lynx
    lzo
    markdown
    maven
    memcached
    mercurial
    mpfr
    ncurses
    netpbm
    nettle
    nmap
    node
    oniguruma
    opencore-amr
    openexr
    openjdk
    openjpeg
    openssl@1.1
    opus
    p11-kit
    pcre
    pcre2
    perl
    pixman
    pkg-config
    pmd
    postgresql
    pypy
    python
    python3
    rabbitmq
    readline
    rename
    rtmpdump
    rubberband
    sdl2
    shared-mime-info
    snappy
    speex
    sqlite
    ssh-copy-id
    tcl-tk
    telnet
    terminal-notifier
    tesseract
    the_silver_searcher
    theora
    tmux
    tree
    typescript
    unbound
    vim
    webp
    wget
    wxmac
    x264
    x265
    xmlstarlet
    xvid
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
brew tap adoptopenjdk/openjdk

# Can list using the command `brew list --cask`
CASKS=(
    adoptopenjdk8
    java
    skype
    spotify
    dropbox
    google-chrome
    macvim
    slack
    sublime-text
    firefox
    intellij-idea
    microsoft-office
    sourcetree
    vagrant
    iterm2
    sfdx
    visual-studio-code
)

echo "Installing cask apps..."
for CASK in ${CASKS[@]}; do
    brew install --cask ${CASK}
done

echo "Installing fonts..."
brew tap homebrew/cask-fonts
FONTS=(
    font-inconsolidata
    font-roboto
    font-clear-sans
    font-hack-nerd-font
)
for FONT in ${FONTS[@]}; do
    brew install --cask ${FONT}
done

# MAS_APPS=(
#     409183694
#     1107421413
# )
# echo "Installing Mac App Store apps..."
# mas install ${MAS_APPS[@]} P

echo "Installing global npm packages..."
NPM_PACKAGES-(
    marked
    prettier
    prettier-plugin-apex
    yarn
)
for NPM_PACKAGE in ${NPM_PACKAGES[@]}; do
    npm install ${NPM_PACKAGE} -g
done

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
/usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Normal Font" HackNerdFontComplete-Regular 12' ~/Library/Preferences/com.googlecode.iterm2.plist
/usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Use Non-ASCII Font" false' ~/Library/Preferences/com.googlecode.iterm2.plist
/usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Cursor Type" 1' ~/Library/Preferences/com.googlecode.iterm2.plist

# can generate the list by executing `code --list-extensions`
echo "Installing vs code extensions..."
CODE_EXTENSIONS=(
    andys8.jest-snippets
    blzjns.vscode-raml
    chuckjonas.apex-pmd
    coddx.coddx-alpha
    dbaeumer.vscode-eslint
    donjayamanne.githistory
    DotJoshJohnson.xml
    eamodio.gitlens
    emilast.LogFileHighlighter
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
    ms-toolsai.jupyter
    oliversturm.fix-json
    redhat.java
    redhat.vscode-yaml
    salesforce.salesforce-vscode-slds
    salesforce.salesforcedx-vscode
    salesforce.salesforcedx-vscode-apex
    salesforce.salesforcedx-vscode-apex-debugger
    salesforce.salesforcedx-vscode-apex-replay-debugger
    salesforce.salesforcedx-vscode-core
    salesforce.salesforcedx-vscode-lightning
    salesforce.salesforcedx-vscode-lwc
    salesforce.salesforcedx-vscode-visualforce
    scala-lang.scala
    shardulm94.trailing-spaces
    spoonscen.es6-mocha-snippets
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

cp templates/.zshrc ~/.zshrc
cp templates/.custom_aliases ~/.custom_aliases
cp -R templates/.custom_config ~/

echo "Installing/updating oh-my-zsh"
if [[ -d ~/.oh-my-zsh ]]; then
    upgrade_oh_my_zsh
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Bootstrapping complete"
