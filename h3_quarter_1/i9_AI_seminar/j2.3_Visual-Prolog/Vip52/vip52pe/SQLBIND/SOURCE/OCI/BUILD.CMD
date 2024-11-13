%OS2_CC_DIR%ICC /C /G3s /Ti /O- /Ms /J /Smsp4 /W3 /Ko /Dmemmodel=1 /I.. /I%oracle_INCL% /I%PRO_DIR%FOREIGN\IBMC\ /Foocibind.obj ocibind.c
lib ..\..\lib\os2_32\ibmc\ocibind -+ocibind.obj ;
