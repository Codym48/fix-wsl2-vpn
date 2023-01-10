WSL2 distributions on Windows hosts can't reach the internet or the intranet when connected over Palo Alto Networks GlobalProtect VPN. This is a known issue:
- https://github.com/microsoft/WSL/issues/4698
- https://github.com/microsoft/WSL/issues/5068

The script in this repository automates implementation of the solution described in https://janovesk.com/wsl/2022/01/21/wsl2-and-vpn-routing.html

## Guiding Principles
- Script doesn't require installing any dependencies (no python, etc.) for ease of use
- Script is completely self-contained in a single file

## Usage
1. Download [fix-wsl2-vpn.cmd](fix-wsl2-vpn.cmd)
2. Right click > Run as administrator
