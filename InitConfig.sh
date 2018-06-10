#!/bin/bash
## Florent DUFOUR
### My automated software installation after a clean install (for macOS Sierra)

#----------------------------------------------------------------
## Add softwares here:

declare -a brew=(
'ccat'
'duti'
'exiftool'
'ffmpeg'
'fish'
'gcc'
'git'
'mas'
'maven'
'node'
'pandoc'
'pandoc-citeproc' # Because life is too short
'python3'
'tree'
'youtube-dl')

declare -a cask=( # Some casks need it to be installed beforehand
'xquartz' # Some casks rely on xquartz as a dependency: has to be first
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
'imagej'
'inkscape'
'iterm2'
'java8'
'mactex-no-gui' # That's heavy!
'macvim'
'onyx'
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
'p5xjs-autocomplete'
'wordcount')

declare -a mas=(
'937984704'  # Amphetamine
'1229643033' # Am I online
'641027709'  # Color Picker
'1033480833' # Decompressor (Because someone will someday send you a .rar ...)
'409183694'  # Keynote
'576338668'  # Leaf
'715768417'  # Microsoft remote desktop
'409203825'  # Numbers
'409201541') # Pages

declare -a pip=(
'livereload'
'matplotlib'
'pandas')     # Comes along other useful libraries such as numpy


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
    sudo npm install -g "$n"
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

mas signin --dialog dufour.florent@icloud.com  # Displays a dialog box to login

for m in "${mas[@]}"
do
  echo -e "> Installing Mac app store Apps $m"
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

sudo osascript SetHotCorners.scpt # The AppleScript has to be in the same directory

#TODO: Activate & configure firewall

### ultimate vim rc

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

### Fish shell

fishPath=`which fish`
echo $fishPath | sudo tee -a /etc/shells  # Add Fish to the list of supported shells
chsh -s $fishPath                         # Make fish the default shell

### Atom configuration

apm disable welcome
#TODO: activate scroll past end

### Set default applications (using duti and inline applescripting)

duti -s "$(osascript -e 'id of app "Typora"')" md all
duti -s "$(osascript -e 'id of app "Chromium"')" html all

declare -a iinaFormats=(mp3 mp4 mkv avi webm) #Add other formats here

for format in "${iinaFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "IINA"')" $format all
done

declare -a macvimFormats=(txt log dat sh fasta f90 f95 srt csl bib) #Add other formats here

for format in "${macvimFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "macvim"')" $format all
done

declare -a decompressorFormats=(rar) #Add other formats here

for format in "${decompressorFormats[@]}"
do
  duti -s "$(osascript -e 'id of app "Decompressor"')" $format all
done

#----------------------------------------------------------------
#Clean and reboot:

read -p "Remove cached packages/images now ? (Y/N): " remove

if [  $remove = 'Y'  ] || [  $remove = 'y'  ]
then
  rm -rf "$(brew --cache)"
fi

echo -e '\n\tREBOOTING\n'
read -p "Reboot now ? (Y/N): " reboot

if [  $reboot = 'Y'  ] || [  $reboot = 'y'  ]
then
  sudo shutdown -r now "Rebooting. Installation completed.";
fi
