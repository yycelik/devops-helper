#Requires -RunAsAdministrator

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#install choco
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#developer
choco install 7zip -y
choco install winmerge -y
choco install notepadplusplus -y
choco install notepadplusplus -y
choco install mremoteng -y
choco install virtualbox -y
choco install lightshot -y

#game
#choco install steam