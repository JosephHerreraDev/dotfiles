#!/bin/bash

# Install base dependencies for building AUR packages
sudo pacman -S --needed --noconfirm base-devel git

# Install yay if not installed
if ! command -v yay &> /dev/null; then
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi