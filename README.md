# TruncateDatabaseCruft

Truncate tables in a database to remove cruft.
It is specifically written [D365FO](https://docs.microsoft.com/de-de/dynamics365/fin-ops-core/fin-ops/) databases when transferred from Prod to DEV systems.


# How to use

1.  Start TruncateDatabaseCruft.exe. The files in the Script directory are not needed for this.
2.  Enter name of the database.
3.  Enter endings of tables to be truncated. Either one after the other, or all together separated by comma.
    Use only letters, numbers and comma.
    If you use it for the previously mentioned objective, you may want to truncate _staging_ and _history_.
4.  If you enter a wrong table, use the dropdown to delete them.
5.  Select the "Delete data"-button to start truncating the tables.

![image](https://user-images.githubusercontent.com/47419982/154085244-bcf54490-0920-44cb-b88d-c6eb2c17b2a1.png)


# How to change the scripts

The program contains a SQL, a PowerShell and an [AutoIt](https://www.autoitscript.com/site/) script. For the AutoIt script you can use [SciTE](https://www.autoitscript.com/site/autoit-script-editor/) as an editor.
