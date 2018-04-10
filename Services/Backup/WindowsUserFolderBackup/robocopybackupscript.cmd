@echo off

rem This script will copy the User folder on the WindowsVM to the ArchServer's SMB share for backup
rem Echo is turned off, so command prompt does not appear on screen

rem general variables

set backupcmd=robocopy 
set backupcmdoptions=/MIR /R:0 /W:0 /FFT /XJD /NP /NDL
set logfile=\\ARCHSERVER\Fileserver\Applications\Backup\logs\windowsvmuserfolder.log

rem variables for user folder backup

set sourcedrive=C:\Users\ArchServer
set backupdrive=\\ARCHSERVER\Media\SystemImage\WindowsVMUserFolder

rem variables for steam shortcuts backup
set sourcedrivesteam="C:\Program Files (x86)\Steam\userdata\95940292\config"
set sourcedrivesteam2="C:\Program Files (x86)\Steam\userdata\95940292\7\remote"

set backupdrivesteam=\\ARCHSERVER\Media\SystemImage\WindowsVMUserFolder\steam_config
set backupdrivesteam2=\\ARCHSERVER\Media\SystemImage\WindowsVMUserFolder\steam_config2

rem Backing up User folder
echo %Date% %Time% # # Backing up ArchServer user folder >> %logfile%
%backupcmd% %sourcedrive% %backupdrive% %backupcmdoptions% >> %logfile%

rem Backing up steam config folder

%backupcmd% %sourcedrivesteam% %backupdrivesteam% %backupcmdoptions% >> %logfile%
%backupcmd% %sourcedrivesteam2% %backupdrivesteam2% %backupcmdoptions% >> %logfile%

echo %Date% %Time% # # Backup Complete >> %logfile%
