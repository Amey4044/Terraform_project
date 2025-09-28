#!/bin/bash
# Update & install packages
sudo apt-get update -y
sudo apt-get install -y nginx mysql-server
sudo systemctl enable nginx mysql
sudo systemctl stop nginx mysql  # Stop services before packaging
