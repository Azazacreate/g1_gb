
	Portable SQL bindings (SQLBIND)
	===============================

The SQLBIND layer implements a portable interface towards several different Database Application Programming Interfaces (API's). The SQLBIND binding layer implements only a subset of the API's.

The following API's are included in the bindings:
* The Microsoft Open Data Base Connectivity (ODBC)
* The Oracle Call Interface (OCI)
* The IBM DataBase/2 (DB/2)

Note:
 These bindings is supplied AS IS ! They are being used in a number of commercial
 daily used projects, but only the functionality needed for these projects have
 been implemented. Especially the direct Oracle bindings might miss some features
 in a given project. But the full source are included, and if you make enhancements,
 please send these back to PDC, so they will be included in future releases !


GENERAL INFORMATION

Visual Prolog programs that call SQLBIND predicates must include the SQLBIND.DOM and SQLBIND.PRE header files from the SQLBIND\INCLUDE subdirectory and they must be linked with one of the following libraries: ODBCBIND.LIB, OCIBIND.LIB or DB2BIND.LIB.
The SQLBIND functions can also be called from C modules; they must include the SQLBIND\SOURCE\SQLBIND.H header file.

Each SQLBIND predicate name starts with the prefix "sql_". In most cases, the SQLBIND predicates work much like their ODBC counterparts.

The example program SQLBIND\EXAMPLES\SQLDEMO.PRO illustrates the possible use of the SQLBIND predicates. A typical SQLBIND session begins with a call to sql_Connect(..), and is ended with a call to sql_Disconnect(..). Within a session, SQL commands to the Database is carried out by calling sql_Exec(..) and returned data are retrieved by calling sql_FetchNext(..) for each row of data and either sql_GetString(..)/sql_GetInterger(..) etc. OR sql_GetColData(..) for each data item. Ending an SQL query (sql_Exec .. sql_FetchNext .. sql_Get..) a call to sql_Drop(..) must be issued.


SETTING UP THE ODBC DRIVER TO RUN THE SQLBIND EXAMPLE "SQLDEMO".

1. Choose the Main group from the Windows Program manager
2. Choose the Control Panel from the main group
3. If you do not see an ODBC icon you must install the ODBC option from 
Visual Basic, Microsoft Access or another program that contains it. 
(ODBC is not supplied with VP).
4. Choose the ODBC item the Program Managers Control Panel
5. If you do not see a MS Access (*.mdb) item in the Data Sources Window 
Choose the Add option, Select the "Access" item and press the OK button.
6. When the ODBC setup window comes up enter the text SQLBIND_demo  
(without quotes) into the Data Source Name box.
7. Choose the Select Database option.
8. Use the file selection dialog to find the PERSONS.MDB database in the 
SQLBIND\EXAMPLES directory of your Visual Prolog installation.
9. Click on the persons.mdb item or write it into the File Name box.
10. Press OK, OK
11. Now you should see the Data Sources window again, this time it should 
contain a reference to the SQLBIND_Demo data source.

Compiling, linking and executing the SQL example.

1. In order to compile without errors the following should be in the Options, Include box: 
.;$(PRODIR)include;$(PRODIR)vpi\include;$(PRODIR)vpi\include
2. Normally the VPI calls the linker directly. If you have limited memory or just 
want to see if the linking completes without problems you should select the Use DOS 
mode during build option from the Options, Environment menu.
3. Select the Run option from the Project menu.
4. If you selected the Use DOS mode during build option you will see the linker working 
in a DOS box, It should link without errors and then ask you to press a key.
5. If you selected the Use DOS mode during build option the VPI will be unable 
to start the generated executable. You can do this by using the Run option from the 
Program Managers File menu.
6. If the program starts by showing a message box asking you to configure the 
ODBC driver please check that you have correctly followed the above instructions 
for Setting up the ODBC driver.


