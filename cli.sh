#! /bin/sh -u

# Colors
red='\033[31m'
cyan='\033[36m'
blue='\033[34m'
green='\033[32m'
purple='\033[35m'
orange='\033[33m'
grey='\033[37m'
# No Color
NC='\033[00m'
# Styles
bold='\033[1m'
normal='\033[0m'

# Configurable environment variables
  # Path to installation
  HOSTER_PATH=${HOSTER_PATH:="$HOME/.hoster"}
  # Path to original hosts
  HOST_FILE=${HOST_FILE:="/etc/hosts"}
# Current user
USER=$(whoami)
# Current active host
ACTIVE_HOST_NAME=$(readlink -e $HOSTER_PATH/active | tr '/' '\n' | tail -n 1)
# Current active host path
ACTIVE_HOST=$HOSTER_PATH/active
# The original host path
ORIGINAL_HOST=$HOSTER_PATH/original

# Checks if installed or not, kind of crappy...
installed() {
  if [ -d "$HOSTER_PATH" ]; then
    return 0
  else
    return 1
  fi
}
installed
installed=$?


# Installs hoster unless already exists in $HOSTER_PATH
install_hoster() {
  if [ $installed = 0 ] ; then
    echo "Hoster is already installed!"
    echo "Please remove if you want to re-install"
    echo "Current HOSTER_PATH: $HOSTER_PATH"
    exit 1
  fi
  mkdir -p $HOSTER_PATH
  echo "Running install [Remember to run as root if original host is /etc/hosts]"
  echo "Backing up your original hosts file!"
  cp $HOST_FILE $ORIGINAL_HOST
  echo "Setting original as active host"
  ln -s $ORIGINAL_HOST $ACTIVE_HOST
  echo "Removing old hosts file"
  rm $HOST_FILE
  echo "Symlinking Hoster's active host file to $HOST_FILE"
  ln -s $ACTIVE_HOST $HOST_FILE
  echo ""
  echo "## Installation done! Run \`hoster help\` to see all commands"
  exit 0
}

# Prints the current active host
get_active_host() {
  echo ${NC}Active:${cyan} $ACTIVE_HOST_NAME
}

# Prints the help message with the appropriate status for the installation
# TODO needs cleanup
print_help_message() {
  if [ "$1" = "TRUE" ] ; then # If <install> is true
    STATUS=$(get_active_host)
    COLOR=${cyan}
  else
    STATUS="Status: ${red}${bold}Hoster is not installed"
    COLOR=${red}
  fi
  echo "$COLOR$STATUS ${NC}"
  echo "Usage: hoster [command]"
  echo "\t${purple}[No command]"
  echo "\t  ${orange}>${NC}  Shows the current active host file"
  if [ "$1" = "TRUE" ] ; then # If <install> is true
    echo "\t${purple}install${NC}"
    echo "\t  ${orange}>${NC}  Installs hoster in your home-folder"
  else
    echo "\t> ${green}install${NC}"
    echo "\t  ${green}>  Installs hoster in your $HOSTER_PATH (default: $HOME/.hoster)${NC}"
  fi
  echo "\t${purple}use ${NC}${grey}<file>${NC}"
  echo "\t  ${orange}>${NC}  Uses a hosts-version, see list with \`list\`-command"
  echo "\t${purple}create ${NC}${grey}<new_name>${NC}"
  echo "\t  ${orange}>${NC}  Creates as new host file, based on your original host file"
  echo "\t${purple}list${NC}"
  echo "\t  ${orange}>${NC}  See all available host files you can \`use\`"
}


# If hoster is installed in $HOSTER_PATH
if [ $installed = 0 ] ; then

  # If no arguments
  if [ $# -eq 0 ] ; then
      get_active_host
      exit
  fi

  if [ "$1" = 'help' ] ; then
    print_help_message "TRUE"
  fi

  # Create new hostsfile
  if [ "$1" = 'create' ] ; then
    cp $ORIGINAL_HOST $HOSTER_PATH/$2
  fi

  # Installs hoster in $HOSTER_PATH
  if [ "$1" = 'install' ] ; then
    install_hoster
  fi

  # Switches active host file to the one specified in the second argument
  if [ "$1" = 'use' ] ; then
    if [ -z "$2" ] ; then
      echo "You forgot to specify what host file you want to use. See a list with \`list\`-command."
      exit 1
    else
      rm $ACTIVE_HOST
      ln -s $HOSTER_PATH/$2 $ACTIVE_HOST
      echo "Done! You are now using $2"
    fi
  fi

  list_all_hosts() {
    ls -1 $HOSTER_PATH
  }

  if [ "$1" = 'list' ] ; then
    list_all_hosts
  fi

  if [ "$1" = 'ls' ] ; then
    list_all_hosts
  fi
else
  # Hoster is not installed!
  # If no arguments
  if [ $# -eq 0 ] ; then
      print_help_message "FALSE"
  else
    # Only enable help and install if Hoster is not installed
    if [ "$1" = 'install' ] ; then
      install_hoster
    fi
    if [ "$1" = 'help' ] ; then
      print_help_message "FALSE"
    fi
  fi
fi
