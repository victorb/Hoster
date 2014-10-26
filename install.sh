PREFIX=${PREFIX:=/usr/bin}

echo "## Beginning installation into $PREFIX"

echo "## Cloning latest source"
git clone git://github.com/victorbjelkholm/Hoster.git /tmp/hoster_installation

cd /tmp/hoster_installation

echo "## Building..."
make build

finish_installation()
{
  rm -rf /tmp/hoster_installation
  echo "## Installation done!"
  echo ""
  echo "Run \`hoster help\` to see instructions on usage"
}

echo "## Installing executable"
if cp hoster $PREFIX/hoster; then
  finish_installation
else
  echo "## Trying to install with sudo"
  sudo cp hoster $PREFIX/hoster
  finish_installation
fi

