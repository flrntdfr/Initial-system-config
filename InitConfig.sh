#!/bin/bash
## Florent DUFOUR
### My automated software installation after a clean install (for macOS Sierra)

#TODO: Add mac App store applications install with mas-cli (https://github.com/mas-cli/mas)
#TODO: Further configuration of fish shell
#TODO: Add snippets in clipy (common Java methods...)
#TODO: Set default applications (mac-vim, IINA, iterm2, Chromium)
#TODO: What about GPG config ? Recover private Keys...
#TODO: restore macOS active edges

#----------------------------------------------------------------
## Add software here:

declare -a brew=(
'git'
'node'
'exiftool'
'ffmpeg'
'fish'
'maven'
'pandoc'
'python3'
'youtube-dl'
'tree'
'ccat')

declare -a cask=(
'atom'
'boostnote'
'chromium'
'clipy'
'coconutbattery'
'dropbox'
'eclipse-ide'
'evernote'
'flux'
'font-open-sans'
'github' #Formerly github-desktop
'goofy'
'gpg-suite'
'grammarly'
'iina'
'iterm2'
'java8'
'mactex-no-gui' #That's heavy!
'macvim'
'processing'
'rocket'
'scenebuilder'
'skype'
'spectacle'
'textstudio'
'transmission'
'typora'
'wwdc'
'zotero')

declare -a npm=(
'p5-manager')

declare -a apm=(
'atom-beautify'
'atom-live-server'
'autocomplete-java'
'dark-flat-ui'
'emmet'
'highlight-selected'
'linter'
'linter-htmlhint'
'linter-javac'
'linter-jscs'
'linter-jshint'
'linter-jsonlint'
'linter-markdown'
'linter-shellcheck'
'linter-stylelint'
'linter-ui-default'
'minimap'
'outlander-syntax'
'p5xjs-autocomplete')

declare -a mas=(
'Amphetamine'
'Color Picker'
'Am I online')

declare -a pip=(
'pandas'      # Comes along other useful libraries such as numpy
'matplotlib'
)

#----------------------------------------------------------------
## Install homebrew:

echo -e '\n\tINSTALLING HOMEBREW \n'
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#----------------------------------------------------------------
## Setup:

echo -e '\n\tTAPPING \n'
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

#----------------------------------------------------------------
## Loop through the installs:

echo -e '\n\tMESSING WITH INSTALLS \n'

# Install casks first (some brews may rely on casks. i.e. maven needs java7+ to be installed beforehand)

for c in "${cask[@]}"
do
    echo -e "> Installing cask $c \n"
    brew cask install "$c";
done

# Install brews

for b in "${brew[@]}"
do
    echo -e "> Installing brew: $b \n"
    brew install "$b";
done

# Install node packages

for n in "${npm[@]}"
do
    echo -e "> Installing node $n "
    sudo npm install "$n" -g
done

# Install atom packages

atom     # Open atom for the first time so the apm command is available
sleep 30 # Wait for atom to be launched

for a in "${apm[@]}"
do
    echo -e "> Installing atom libraries $a"
    apm install "$a"
done

# Install app from mac app store

# TODO?

# Install python packages

for p in "${pip[@]}"
do
  echo -e "> Intalling python libraries"
  pip3 install "$p"
done

#----------------------------------------------------------------
## Other configuration:

echo -e '\n\tMESSING WITH OTHER CONFIGS\n'

### Wallpapers

destination='/Library/Desktop\ Pictures' #(For macOS Sierra)

curl http://512pixels.net/downloads/macos-wallpapers/10-5.png -o 'Leopard.png'
curl http://512pixels.net/downloads/macos-wallpapers/10-6.png -o 'Snow-Leopard.png'

sudo mv Leopard.png "$destination/Leopard.png"
sudo mv Snow-Leopard.png "$destination/Snow-Leopard.png"

osascript -e 'tell application "System Events" to set picture of every desktop to ("/Library/Desktop Pictures/Leopard.png" as POSIX file as alias)'

### ultimate vim rc

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

### Fish shell

fishPath=`which fish`
echo $fishPath | sudo tee -a /etc/shells  # Add Fish to the list of supported shells
chsh -s $fishPath                         # Make fish the default shell

### Atom configuration

apm disable welcome

#----------------------------------------------------------------
#Clean and reboot:

read -p "Remove cached images now ? (Y/N) " remove

if [  $remove = 'Y'  ] || [  $remove = 'y'  ]
then
  rm -rf "$(brew --cache)"
fi

echo -e '\n\tREBOOTING\n'
read -p "Reboot now ? (Y/N) " reboot

if [  $reboot = 'Y'  ] || [  $reboot = 'y'  ]
then
  sudo shutdown -r now "Rebooting. Installation completed";
fi
