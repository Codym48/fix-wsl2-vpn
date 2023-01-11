WSL2 distributions on Windows hosts can't reach the internet or the intranet when connected over Palo Alto Networks GlobalProtect VPN. This is a known issue:
- https://github.com/microsoft/WSL/issues/4277
- https://github.com/microsoft/WSL/issues/4698
- https://github.com/microsoft/WSL/issues/5068
- https://github.com/microsoft/WSL/issues/5336
- https://github.com/microsoft/WSL/issues/7159
- https://github.com/microsoft/WSL/issues/7822

The script in this repository automates implementation of the solution described in https://janovesk.com/wsl/2022/01/21/wsl2-and-vpn-routing.html

Note this differs from the [official workaround](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting#wsl-has-no-network-connectivity-once-connected-to-a-vpn) from Microsoft. That change requires the developer to do something on every switch between a non-VPN and a VPN connection _and vice versa_, or take a performance hit on one side as described in @janovesk's [2nd blog post](https://janovesk.com/wsl/2022/01/24/wsl2-and-vpn-dns.html). For comparison, this script is only necessary on each (re)connection to VPN. The effects of this script should not persist or impact non-VPN connections.

## Development Goals
- Script doesn't require installing any dependencies (no python, etc.) for ease of use
- Script is completely self-contained in a single file for ease of acquisition
- Script is a batch script, since some corporate IT settings restrict who can run PowerShell scripts with elevated privileges

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

## Testing

Manually tested with
- Palo Alto Networks GlobalProtect VPN 5.2.12-26
- Windows 10 Enterprise 10.0.19045 Build 19045
- Windows PowerShell 10.0.19041.546
- Command Prompt 10.0.19041.746
- WSL versions
  ```
  C:\Users\Codym48\Code\fix-wsl2-vpn>wsl -l -v
    NAME                   STATE           VERSION
  * Ubuntu                 Running         2
    docker-desktop-data    Stopped         2
    docker-desktop         Stopped         2
  
  C:\Users\Codym48\Code\fix-wsl2-vpn>wsl --version
  WSL version: 1.0.3.0
  Kernel version: 5.15.79.1
  WSLg version: 1.0.47
  MSRDC version: 1.2.3575
  Direct3D version: 1.606.4
  DXCore version: 10.0.25131.1002-220531-1700.rs-onecore-base2-hyp
  Windows version: 10.0.19045.2364
  ```