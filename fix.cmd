rem Execute this script in an elevated command prompt to fix issues with WSL2
rem distributions connecting to the internet through a VPN like GlobalProtect.
rem
rem Before running the script:
rem Windows Key + Ubuntu
rem username@computer-name:~$ ping 8.8.8.8
rem PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
rem _
rem
rem To run the script:
rem 1. Windows Key -> File Explorer -> Open
rem 2. Navigate to this script
rem 3. Right Click -> Run as administrator
rem 
rem After running the script:
rem Windows Key + Ubuntu
rem username@computer-name:~$ ping 8.8.8.8
rem PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
rem 64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=10.7 ms
rem 64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=11.0 ms
rem 64 bytes from 8.8.8.8: icmp_seq=3 ttl=115 time=10.4 ms
rem ...

set wsl_adapter_ip=172.21.0.0
set wsl_adapter_mask=255.255.240.0
set vpn_adapter_index=17

:loop
call route delete %wsl_adapter_ip% mask %wsl_adapter_mask% 0.0.0.0 ^
 IF %vpn_adapter_index% > route-delete-result.txt 2>&1
set /p result=<route-delete-result.txt
if "%result%"==" OK!" goto loop
