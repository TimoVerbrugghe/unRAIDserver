Set WshShell = CreateObject("WScript.Shell")
cmds=WshShell.RUN("C:\Users\ArchServer\Desktop\BackupScript\robocopybackupscript.cmd", 0, True)
Set WshShell = Nothing