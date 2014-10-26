## Hoster

Easy manage host files via a CLI

## Installation

Installing is a simple as ABC

```curl -L https://raw.githubusercontent.com/victorbjelkholm/Hoster/master/install.sh | sh```

Default install is in ```/usr/bin```, if you want to change it, add a PREFIX environment variable before the curl command.

```PREFIX=/home/victor/bin curl -L https://raw.githubusercontent.com/victorbjelkholm/Hoster/master/install.sh | sh```

## Usage

```hoster``` Without any argument, hoster prints the current active hostfile

```hoster install``` Install hoster into a path where all the hosts file are stored.

```hoster use hostfile1``` Uses host file with filename ```hostfile1``` as the current, active host file.

```hoster list``` Lists all the hosts file inside the folder where hoster is installed.

## Testing, Building & Installing

```make test``` Runs the test, shunit2 is needed for this ( https://code.google.com/p/shunit2/ )

```make build``` Build an executable from the shellscript

```make install``` Installs the executable to /usr/bin/hoster. If you want to install elsewhere, just copy the ```hoster``` executable to wherever you want after running ```make build```

## Contributing

Just submit a Pull Request and/or report issues you find. If something is unclear,
please help me make it better for others.

## Planned features

* "Namespaces" via dots in filenames
* Autocompletion
