#!/usr/bin/env bash
# Install command-line tools using Homebrew.

# some variables for output formatting 
bold=$(tput bold)
normal=$(tput sgr0)

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# get the list of installed formulaes and casks
readarray -t installed_formulaes <<< "$(brew list)"
readarray -t installed_casks <<< "$(brew cask list)"

function containsElement() {
  local e match="$1"
  shift

  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

function brew-install() {
	formulae=$1

	if containsElement "${formulae}" "${installed_formulaes[@]}"; then
		echo " ⏩ skip ${bold}${formulae}${normal}, already installed"
	else
		brew install ${formulae}
	fi
}

function brew-cask-install() {
	cask=$1

	if containsElement "${cask}" "${installed_casks[@]}"; then
		echo " ⏩ skip cask ${bold}${cask}${normal}, already installed"
	else
		brew cask install ${cask}
	fi
}

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew-install coreutils
if [[ ! -f ${BREW_PREFIX}/bin/sha256sum ]]; then
	ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
fi

# Install some other useful utilities like `sponge`.
brew-install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew-install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew-install gnu-sed --with-default-names
# Install Bash 4.
brew-install bash

# Install GnuPG to enable PGP-signing commits.
brew-install gnupg

# Install more recent versions of some macOS tools.
brew-install vim --with-override-system-vi
brew-install grep
brew-install openssh

# Install font tools.
brew tap bramstein/webfonttools
brew-install sfnt2woff
brew-install sfnt2woff-zopfli
brew-install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
#brew-install aircrack-ng
#brew-install bfg
#brew-install binutils
#brew-install binwalk
#brew-install cifer
#brew-install dex2jar
#brew-install dns2tcp
#brew-install fcrackzip
#brew-install foremost
#brew-install hashpump
#brew-install hydra
#brew-install john
#brew-install knock
#brew-install netpbm
brew-install nmap
#brew-install pngcheck
#brew-install socat
#brew-install sqlmap
#brew-install tcpflow
#brew-install tcpreplay
#brew-install tcptrace
#brew-install ucspi-tcp # `tcpserver` etc.
#brew-install xpdf
#brew-install xz

# Install other useful binaries.
brew-install ack
#brew-install exiv2
brew-install git
brew-install git-lfs
brew-install diff-so-fancy
#brew-install imagemagick --with-webp
#brew-install lua
#brew-install lynx
#brew-install p7zip
#brew-install pigz
#brew-install pv
#brew-install rename
#brew-install rlwrap
#brew-install ssh-copy-id
brew-install tree
#brew-install vbindiff
#brew-install zopfli
brew-install autojump
brew-install safe-rm
brew-install autojump
brew-install watch
brew-install yank
brew-install fx

# python 3 dev
brew-install python

# ML
brew-install octave

# java & friends
brew-cask-install java
brew-install kotlin
brew-install scala
brew-install sbt

# other dev languages
brew-install ocaml

# js dev
brew-install node

# middlewares
brew-install apache-spark

# mongo
brew-install mongodb@3.6
brew-cask-install mongotron

# tune macos "quick look" to handle more files
brew-cask-install qlstephen

# tmux
brew-install tmux

# zsh
brew-install zsh
brew-install rbenv
brew-install zsh-syntax-highlighting

# some macos apps
brew-cask-install yakyak

# Remove outdated versions from the cellar.
brew cleanup
