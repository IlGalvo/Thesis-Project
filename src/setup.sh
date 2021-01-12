#!/usr/bin/env bash

# Pithon3 and pip3 are required

sudo apt update -y
sudo apt upgrade -y

if [ $(dpkg -s gringo | grep -c "install ok installed") -eq 0 ]
then
   sudo apt install gringo -y
fi

if [ $(dpkg -s graphviz | grep -c "install ok installed") -eq 0 ]
then
   sudo apt install graphviz -y
fi

if [ $(pip3 list | grep -c "graphviz") -eq 0 ]
then
   sudo pip3 install graphviz
fi