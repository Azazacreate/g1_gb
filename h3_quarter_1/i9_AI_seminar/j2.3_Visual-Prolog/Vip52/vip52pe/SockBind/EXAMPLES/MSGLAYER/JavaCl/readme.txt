--------------------------------------------------------------------------------------------------------------------------------------------------
				Java Applet JavaClient

Copyright (c) Prolog Development Center A/S
Written by Konstantin Ivanov

--------------------------------------------------------------------------------------------------------------------------------------------------

What is JavaClient?

The applet JavaClient is a small example of communication between Prolog-written server and 
Java-written client via sockets.
A role of server in this communication is played by the programm DbServer. DbServer is a Prolog 
example of using Message Layer for creating database client-server applications.
JavaClient connects to a server and can read and change information in databases that are opened
by server programm.


Where to find JavaClient and DbServer?

JavaClient is created for two widespread Java IDE: Symantec Cafe an MS J++. Both projects are archived
by zip. To use JavaClient unzip an archive.
A project of JavaClient for Symantec Cafe is placed in the directory 
	<VPRO>\SockBind\Examples\MsgLayer\JavaCl\SymCafe\
A project of JavaClient for MS J++ is placed in the directory 
	<VPRO>\SockBind\Examples\MsgLayer\JavaCl\MSJ\
Server side programm DbServer is placed in the directory
	<VPRO>\SockBind\Examples\MsgLayer\DbServer\


How to start JavaClient and DbServer?

1. Build JavaClient`s classes with a help of according IDE. In MS J++ open project file JavaClient.mdp; in
    Symantec Cafe open project file JavaClient.prj.
2. Build DbServer programm with the help of Visual Prolog.
3. Run DbServer and read its help information. Make necessary actions to open databases and set server to
    listen mode for incoming requests.
4. Open JavaClient.html file by an Internet browser. Note that now JavaClient works only under Netscape 
    Navigator. Browser automatically will load JavaClient classes.
Now both programms are ready for communication.


What can be done by JavaClient?

  To connect to DbServer press button "Connect" and in a dialog enter a name of the host where DbServer is 
running and a number of a port where DbServer is listening.
  To disconnect from DbServer press button "Disconnect".

When connection is established a choice-box "Database name" contains names of open at server databases.
  To view keys of particular database select its name in choice-box, then keys of database will be shown in list 
"Key".
  To view a key value select a necessary key in a list, then key value will be shown in text field "Value".

When connection is established buttons "New" and "Edit" are enabled.
  To add a new key and its value to a particular database select necessary database and press "New" button.
The dialog "New Key" allows to enter a name of a new key and its value. Press button "OK" in this dialog to
add a new key.
  To edit an existing key select database and necessary key and then press button "Edit". Text field "Value"
will be enabled to allow to edit key value and buttons "Cancel Edit" and "Save" will be enabled too. To save a 
of key press "Save". To cancel edit of key value press "Cancel Edit" - no changes will be saved at a database
at the DbServer.