#!/bin/bash
## Florent DUFOUR
### My automated software installation after a clean install (for macOS Sierra)

#TODO: Further configuration of fish shell
#TODO: Add snippets in clipy (common Java methods...)
#TODO: What about GPG config ? Recover private Keys...

#----------------------------------------------------------------
## Add software here:

declare -a brew=(
'duti'
'git'
'node'
'exiftool'
'ffmpeg'
'fish'
'gcc'
'mas'
'maven'
'pandoc'
'python3'
'youtube-dl'
'tree'
'ccat')

declare -a cask=(
'xquartz' # Some casks need it to be installed beforehand
'appcleaner'
'atom'
'boostnote'
'chromium'
'clipy'
'coconutbattery'
'dropbox'
'eclipse-ide'
'evernote'
'flux'
'font-latin-modern'
'font-open-sans'
'github' # Formerly 'github-desktop'
'goofy'
'gpg-suite'
'grammarly'
'iina'
'inkscape'
'iterm2'
'java8'
'mactex-no-gui' # That's heavy!
'macvim'
'processing'
'rocket'
'scenebuilder'
'skype'
'spectacle'
'texstudio'
'touchbarserver'
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
'close-on-left' # A necessity...
'dark-flat-ui'
'emmet'
'highlight-selected'
'language-applescript'
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
'937984704'  # Amphetamine
'1229643033' # Am I online
'641027709'  # Color Picker
'409183694'  # Keynote
'576338668'  # Leaf
'409203825'  # Numbers
'409201541') # Pages

declare -a pip=(
'pandas'      # Comes along other useful libraries such as numpy
'matplotlib')

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

atom     # Open atom for the first time so the apm command is made available
sleep 30 # Wait for atom to be launched

for a in "${apm[@]}"
do
    echo -e "> Installing atom libraries $a"
    apm install "$a"
done

# Install app from mac app store

mas signin --dialog dufour.florent@icloud.com  # Disaplays a dialog box to login

for m in "${mas[@]}"
do
  echo -e "> Installing Mac app store App $m"
  mas install "$m"
done

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

### Hot corners

sudo osascript SetHotCorners.scpt

### ultimate vim rc

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

### Fish shell

fishPath=`which fish`
echo $fishPath | sudo tee -a /etc/shells  # Add Fish to the list of supported shells
chsh -s $fishPath                         # Make fish the default shell

### Atom configuration

apm disable welcome

### Set default applications (using duti)

duti -s "$(osascript -e 'id of app "Typora"')" md all
duti -s "$(osascript -e 'id of app "Chromium"')" html all

declare -a iinaFormats=(mp3 mp4 mkv avi) #Add other format here

for format in "${iinaFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "IINA"')" $format all
done

declare -a macvimFormats=(txt log dat sh fasta f90 f95 srt) #Add other format here

for format in "${macvimFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "macvim"')" $format all
done

#----------------------------------------------------------------
#Clean and reboot:

read -p "Remove cached packages/images now ? (Y/N) " remove

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
