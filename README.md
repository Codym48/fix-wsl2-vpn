WSL2 distributions on Windows hosts can't reach the internet or the intranet when connected over Palo Alto Networks GlobalProtect VPN. This is a known issue:
- https://github.com/microsoft/WSL/issues/4698
- https://github.com/microsoft/WSL/issues/5068

The script in this repository automates implementation of the solution described in https://janovesk.com/wsl/2022/01/21/wsl2-and-vpn-routing.html

## Development Goals
- Script doesn't require installing any dependencies (no python, etc.) for ease of use
- Script is completely self-contained in a single file

## Usage
1. Open up your WSL2 distribution (e.g. Windows key > Ubuntu) and run the following command, which should hang. If it doesn't, you already have internet access and can skip the following steps.
    ```
    ping 8.8.8.8
    ```
2. Download [fix-wsl2-vpn.cmd](fix-wsl2-vpn.cmd) to your Windows host
    1. Some browsers, like Edge, may block downloads of .cmd files. Try Firefox or Chrome instead.
    2. Alternatively, download the whole git repository as a .zip file and extract the .cmd file from the archive
3. Right click on fix-wsl2-vpn.cmd > Run as administrator
    1. If you see "Windows protected your PC", click "More info" and then "Run anyway"
4. A command prompt will pop up, print some logs, and disappear. If it works, you should start seeing the following in your WSL2 terminal. You now have a working network connection from inside WSL2!
    ```
    64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=10.7 ms
    64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=11.0 ms
    64 bytes from 8.8.8.8: icmp_seq=3 ttl=115 time=10.4 ms
    ```

Note you'll need to run this script (just step 3) every time you reconnect over VPN.
