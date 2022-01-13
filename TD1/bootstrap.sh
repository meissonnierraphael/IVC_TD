#! /usr/bin/env bash

sudo add-apt-repository ppa:ubuntu-toolchain-r/test

# Ne faire update que si ca ne casse pas des installations preexistantes dans l'image de base
sudo apt-get update
# sudo apt-get -y upgrade

# Faire des installations de packages / logiciels specifiques.
# On peut chercher les packages dans le dépôt pour la distribution d'OS de l'image de base.
# Pour Ubuntu : https://packages.ubuntu.com/

# Par exemple, pour gérer du code C/++
# sudo apt-get -y install software-properties-common
# sudo apt-get -y install  gcc-10 g++-10
# sudo apt-get -y install valgrind
# sudo apt-get -y install make

# Pour développer des applications en PHP
sudo apt-get -y install php7.4
sudo apt-get -y install apache2
