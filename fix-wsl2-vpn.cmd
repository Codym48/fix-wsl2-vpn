rem Execute this script in an elevated command prompt to fix issues with WSL2
rem distributions connecting to the internet through a VPN like GlobalProtect.
rem Based on https://janovesk.com/wsl/2022/01/21/wsl2-and-vpn-routing.html
rem
rem Before running the script:
rem Windows Key > Ubuntu
rem username@computer-name:~$ ping 8.8.8.8
rem PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
rem _
rem
rem To run the script:
rem 1. Windows Key > File Explorer > Open
rem 2. Navigate to this script
rem 3. Right Click > Run as administrator
rem 
rem After running the script:
rem Windows Key > Ubuntu
rem username@computer-name:~$ ping 8.8.8.8
rem PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
rem 64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=10.7 ms
rem 64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=11.0 ms
rem 64 bytes from 8.8.8.8: icmp_seq=3 ttl=115 time=10.4 ms
rem ...

rem Assumes a single network whose alias contains "WSL"
for /f "delims=" %%i in (
    ' powershell -NonInteractive -NoProfile -Command "(Get-NetIPConfiguration -InterfaceAlias *WSL*).IPv4Address.IPAddress" '
) do set "wsl_adapter_ip=%%i"
rem We need to delete the route from .0 even though ipconfig returns .1
set "wsl_adapter_ip=%wsl_adapter_ip:~0,-1%0"

rem Use the PrefixLength to calculate the subnet mask via binary math
rem (Assume subnet mask is PrefixLength 1s followed by 32-PrefixLength 0s)
rem https://networkengineering.stackexchange.com/questions/7106/how-do-you-calculate-the-prefix-network-subnet-and-host-numbers
for /f "delims=" %%i in (
    ' powershell -NonInteractive -NoProfile -Command "[int]$prefix_length = (Get-NetIPConfiguration -InterfaceAlias *WSL*).IPv4Address.PrefixLength; [int]$prefix_rem = $prefix_length; [int]$ones = (0,(8,$prefix_rem | Measure -Min).Minimum | Measure -Max).Maximum; [int]$first = [Convert]::ToInt16('1'*$ones+'0'*(8-$ones),2); [int]$prefix_rem = $prefix_rem-8; [int]$ones = (0,(8,$prefix_rem | Measure -Min).Minimum | Measure -Max).Maximum; [int]$second = [Convert]::ToInt16('1'*$ones+'0'*(8-$ones),2); [int]$prefix_rem = $prefix_rem-8; [int]$ones = (0,(8,$prefix_rem | Measure -Min).Minimum | Measure -Max).Maximum; [int]$third = [Convert]::ToInt16('1'*$ones+'0'*(8-$ones),2); [int]$prefix_rem = $prefix_rem-8; [int]$ones = (0,(8,$prefix_rem | Measure -Min).Minimum | Measure -Max).Maximum; [int]$fourth = [Convert]::ToInt16('1'*$ones+'0'*(8-$ones),2); $out = $first,$second,$third,$fourth -join '.'; echo $out" '
) do set "wsl_adapter_mask=%%i"

rem Assumes a single network adapter whose description starts with "PANGP"
for /f "delims=" %%i in (
    ' powershell -NonInteractive -NoProfile -Command "(Get-NetAdapter -InterfaceDescription PANGP*).ifIndex" '
) do set "vpn_adapter_index=%%i"

rem Attempt to delete the route at 1s intervals until the route doesn't exist
:loop
call route delete %wsl_adapter_ip% mask %wsl_adapter_mask% 0.0.0.0 IF %vpn_adapter_index% > route-delete-result.txt 2>&1
set /p result=<route-delete-result.txt
timeout /t 1 > nul
if "%result%"==" OK!" goto loop

del /f route-delete-result.txt
