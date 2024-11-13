The Examples directory contains the following directories

Server
=====
The source code of a simple Calculator COM object written in MSVC++ v.5.0. It builds a self-registering MYCALC3.EXE COM object placed into the \Release subdirectory.

AutoCli
======
The Visual Prolog project creating the executable client CalcCli.EXE, which communicates with MYCALC3.EXE by Automation way.

OOPCli
=====
The Visual Prolog project creating the executable client CalcCli.EXE, which communicates with MYCALC.EXE according to the Binary interfaces way. The calculator component is represented by Prolog's abstract class.

How to Compile and Run Examples.
==========================
1. Go to the Server\Release directory and run the mycalc3.exe application. It will register the component at your computer. This registration at your computer should be done only once. After the successful registration the calculator window appears at your computer screen.

2. Run Visual Prolog Win32 VDE and open the correspondent CALCCLI.PRJ project. 

3. Build the project and run the created CALCCLI.EXE application. Windows corresponding to server (MyCalc3.EXE) and client (CALCCLI.EXE) appear at your screen.  In the client calculator window you can enter digits (using mouse) and invoke arithmetic operations. When you press buttons in the client calculator the results of these operations are displayed in the server calculator window. 
