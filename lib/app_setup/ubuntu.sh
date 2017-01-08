#!/usr/bin/env bash

echo "Are you ready to start?"
echo -n "Type 'yes' or operation will be aborted: "
read answer_for_the_start
if [[ "$answer_for_the_start" != "yes" ]]; then
  echo ""
  echo "Aborted!"
  echo ""
  return
fi

UBUNTU_RELEASE_CODENAME="$(lsb_release -cs)"

export RUN_APT_GET_UPDATE_BEFORE="no"

# upgrade
sudo bash "ubuntu/upgrade/make-upgrade_packages.sh"

# htop
sudo bash "ubuntu/htop/install-htop.sh"

# mc
sudo bash "ubuntu/mc/install-mc.sh"

# mongodb
sudo bash "ubuntu/mongodb/install-mongodb.sh" 3.4 $UBUNTU_RELEASE_CODENAME

#ruby
bash "ubuntu/ruby/install-rvm.sh" stable
bash "ubuntu/ruby/install-ruby.sh" 2.2.3 bundler rubocop

# tree
sudo bash "ubuntu/tree/install-tree.sh"

echo ""
echo "Running: \`source \"$HOME/.bashrc\"\`"
source "$HOME/.bashrc"
