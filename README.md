# TruncateDatabaseCruft

Truncate tables in a database to remove cruft.


# How to use

1.  Start TruncateDatabaseCruft.exe. The files in the Script directory are not needed for this.
1.  Enter name of the database.
2.  Enter endings of tables to be truncated. Either one after the other, or all together separated by comma.
    Use only letters, numbers and comma.
    If you enter a wrong table, use the dropdown to delete them.
3. Select the "Delete data"-button to start truncating the tables.

![image](https://user-images.githubusercontent.com/47419982/154085244-bcf54490-0920-44cb-b88d-c6eb2c17b2a1.png)


# How to change the scripts

The program contains a SQL, a PowerShell and an AutoIt script. For the FileInstall, which is used in creating the .exe, an absolute path has to be given. Change that in the first parameters in lines 24 to 26 in the TruncateTableGUI.au3 file.
