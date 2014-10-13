#! /bin/sh

if [ -z "$1" ] ; then
  echo "No arguments!"
  exit 1
fi

if [ "$1" = 'install' ] ; then
  exit # Safe guard
  echo "Running install"

  echo "Getting root to backup your hosts file!"
  sudo cp /etc/hosts /home/victor/.hoster/hosts.original
  cp /home/victor/.hoster/hosts.original /home/victor/.hoster/hosts
  sudo rm /etc/hosts
  sudo ln -s /home/victor/.hoster/hosts /etc/hosts
fi

if [ "$1" = 'use' ] ; then
  if [ -z "$2" ] ; then
    echo "You need to use something!"
    exit 1
  else
    rm /home/victor/.hoster/hosts
    cp /home/victor/.hoster/$2 /home/victor/.hoster/hosts
    echo "Done! You are now using $2"
  fi
fi

if [ "$1" = 'list' ] ; then
  echo "Getting list of hosts"

  ls -1 /home/victor/.hoster
fi
