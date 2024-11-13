sqlprep sqlbind.sqc %1 /b
%OS2_CC_DIR%ICC /C /G3s /Ti /O- /Ms /J /Smsp4 /W3 /Ko /Dmemmodel=1 /I. /I%DB2_INCL% /I%PRO_DIR%FOREIGN\IBMC /Fosqlbind.obj sqlbind.c
lib db2bind -+sqlbind.obj ;
sqlbind sqlbind.bnd %1