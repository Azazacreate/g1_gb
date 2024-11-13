@echo off

set pro_drive=e:
set pro_dir=\vpro
set pro_path=%PRO_DRIVE%%PRO_DIR%\

set msvc15_path=e:\msvc15\
set msvc20_path=e:\msvc20\
set bc_path=e:\bc45\
set bcos2_path=c:\bcos2\
set ibmc_path=c:\ibm1step\
set tlkt21_path=c:\toolkt21\

set test_environment_overflow=test_environment_overflow
if not x%test_environment_overflow% == xtest_environment_overflow echo Environment overflow
set test_environment_overflow=

