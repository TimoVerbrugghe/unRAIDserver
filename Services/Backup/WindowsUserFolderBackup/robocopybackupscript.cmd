@echo off

rem This script will copy the User folder on the WindowsVM to the ArchServer's SMB share for backup
rem Echo is turned off, so command prompt does not appear on screen


rem variables

set sourcedrive=C:\Users\ArchServer
set backupdrive=\\ARCHSERVER\Media\SystemImage\WindowsVMUserFolder
set backupcmd=robocopy 
set backupcmdoptions=/MIR /R:0 /W:0 /FFT /XJD /NP /NDL
set logfile=\\ARCHSERVER\Fileserver\Applications\Backup\logs\windowsvmuserfolder.log


rem Backing up User folder
echo %Date% %Time% # # Backing up ArchServer user folder >> %logfile%

%backupcmd% %sourcedrive% %backupdrive% %backupcmdoptions% >> %logfile%
 
echo %Date% %Time% # # Backup Complete >> %logfile%