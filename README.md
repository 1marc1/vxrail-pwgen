# vxrail-pwgen
Bash script that generates passwords compatible with Dell VxRail components.

## Requirements
This script runs on Linux and requires recent versions of the following software:

* GNU bash
* pwgen
* shred (strongly recommended)
* column

Of this software, you typically only need to install pwgen: `sudo apt install pwgen`

## Installation
1. Make the script executable: `chmod +x vxrail-pwgen.sh`
2. Run the script: `./vxrail-pwgen.sh`

## Help
Help is available by running `./vxrail-pwgen.sh -h`
