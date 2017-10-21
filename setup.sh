#!/bin/bash

# Variables
bold=`tput bold` # Bold text
nt=`tput sgr0`   # Normal text
cayan='\e[1;36m' # Color light cayan
nc='\e[0m'       # No color

# Install dependencies
echo -e "${cayan}${bold}Installing a fresh install dependencies${nc}${nt}"
sudo apt-get install -y -q build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev autoconf libc6-dev tmux vim git

# Clone Shorty
echo -e "${cayan}${bold}Cloning Shorty${nc}${nt}"
git clone https://github.com/mrifat/shorty.git

# Setup rbenv
cd
echo -e "${cayan}${bold}Setting up rbenv${nc}${nt}"
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

echo '############################################################################' >> .bashrc
echo '############################################################################' >> .bashrc
echo '' >> .bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
echo '' >> .bashrc
echo '############################################################################' >> .bashrc
echo '############################################################################' >> .bashrc

git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
git clone https://github.com/maljub01/rbenv-bundle-exec.git ~/.rbenv/plugins/rbenv-bundle-exec

# Install Ruby
echo -e "${cayan}${bold}Installing Ruby${nc}${nt}"
rbenv install 2.3.1

# We're Done
echo ""
echo -e "${cayan}${bold}===================${nc}${nt}"
echo -e "${cayan}${bold}====We're Done!====${nc}${nt}"
echo -e "${cayan}${bold}===================${nc}${nt}"
echo ""

echo -e "${cayan}${bold}Installing gems${nc}${nt}"
bundle install

echo -e "${cayan}${bold}Configuring the Database${nc}${nt}"
rake db:create db:migrate

echo -e "${cayan}${bold}Running the tests${nc}${nt}"
rspec

echo -e "${cayan}${bold}Starting puma on 4000${nc}${nt}"
puma -p 4000 -t 0:5
