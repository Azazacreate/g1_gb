The MsCom\* subdirectories contain tools and examples, which support and demonstrate using of COM components (ActiveX controls and other types of servers based on the Microsoft Component Object Model) from Visual Prolog programs.

To understand how to use MS components from Visual Prolog programs, the experienced user can investigate source code of the component example written in MSVC++, source code of the layer library written in MSVC++, and the source code of supplied tools and examples written in Visual Prolog.

To find more detailed information about MS COM technology, please read Microsoft's documentation or any other literature related to this task.

The MsCom directory contains the following subdirectories:

Examples
========
The Examples\* subdirectories contain 2 examples, in which the exposed component are accessed by 2 different ways: by Automation and by OOP. The .\Examples\Server\Release subdirectory contains the ready to use executable module of the COM server (MYCALC3.EXE). It is written in C. If you wish to compile/link this example, you should use MSVC++ v. 4.x, 5.x, or 6.x (using MSVC++ 5.x format of import libraries). The component - outproc automation server with dual interface support - implements a simple Calculator. For more detailes see README.TXT file in the Examples directory.

Include
=======
Contains .CON, .DOM, and .PRE files containing Prolog declarations required to use tools implemented in the layer library.

Lib
===
Contains the layer library for communication with MS COM objects.

Source
======
Contains the source code for the layer library, placed to the LIB directory.

The Visual Prolog VDE v.5.x does not provide any support for writing programs using COM components.

Notice that the currently supplied tools do not have the final status and will be modified in the future.

