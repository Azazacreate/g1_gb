
                    Linking C and PDC Prolog


The foreign language interface in PDC Prolog is nearly as good as
it can be, having in mind that Prolog is a logic programming
language. Not only can PDC Prolog easily call other languages,
other languages can also call PDC Prolog predicates. All you have
to do is to declare the language calling convention and there is
no requirement of Prolog being the main module, having control
over initialization. Moreover, the interface has no overhead as
virtually all C types have PDC Prolog counterparts.

The most difficult platform to do interfacing is DOS since the
operating system provides nearly no services and there is no
standardized way of handling memory. Windows and OS/2 are much
easier platforms and they also support DLLs or DDE to link
programs together. Finally, UNIX is by far the easiest, as the
UNIX version of PDC Prolog is built entirely on the standard C
operating system interface UNIX provides.


Important aspects when linking PDC Prolog with C or other
languages
============================================================

    þ  Study, compile and link the example programs from the
       FOREIGN\EXAMPLES directory.

    þ  Use the Visual Prolog Application Expert to set up the
       link scripts. Study the scripts here before creating
       your own.

    þ  If they don't make sense to you, or you don't have
       detailed knowledge of C, you need to learn about C. You
       should also consider learning about language
       implementations, compilation, and what execution of a
       program actually entails.

    þ  If you want to use more advanced features, like calling
       nondeterministic predicates from C or calling routines in
       the PDC Prolog library, you should get hold of a copy of
       the Professional user's Guide. This is sold as a special
       product from PDC.

    þ  When you want to use some of the functions in the Prolog
       library you should include and take a look at PDCRUNT.H


General remarks for C compiler options
======================================

    þ  The C code needs to be compiled with large memory model,
       since all GLOBAL calls from PDC Prolog are FAR calls, and
       all pointers are FAR pointers. This does not apply to the
       32-bit paged memory model of UNIX, which is effectively
       small model.

    þ  Use the same alignment for C structures as in PDC Prolog.
       This usually means BYTE boundaries, except UNIX which is
       dword.

    þ  If your C compiler has an option to prepend underbars on
       global symbols, turn it on, unless you're using the PDC
       Prolog <as "..." > option.

    þ  Do not enable too much optimization until you know that
       everything works. Many C compilers generate non-
       interfaceable, or even wrong, code at full optimization.

    þ  If your C compiler gives you a choice of target processor,
       make sure you choose the correct one. Do not, for
       instance, select the 80286 as the target if your program
       should be able to run on an old 8086-based computer.

    þ  When PDC Prolog uses it's own upstart's code in INIT.OBJ,
       INITW.OBJ etc. the Prolog program will have a full
       stacksegment where DS!=SS. This make stack checking easy,
       if the stackpointer SP reaches zero there is a stack
       overflow. However when linking up to C, PDC Prolog let's C
       control the stacksegment, and if the stacksegment are
       placed in the DGROUP with SS==DS there might be a stack
       overrun before SP reaches zero. In such a case the Prolog
       stack checking have no effect, and it should be carefully
       checked that the stack is big enough.



General notes for linking under plain DOS
=========================================

    þ  If the program hangs the machine, the first thing to check
       should be that the "STACK" segment is the last segment in
       the list of segments in the .MAP file. However,there can
       be one or more zero length segment afterwards. If you find
       that this is not the case in your project, you have either
       made a mistake in the linking, or you might need to modify
       TCFIRST.ASM or MSCINIT.ASM to define some segments before
       the DGROUP.

    þ  All memory handling must be done by the PDC Prolog system.
       In the start-up files MSCINIT.OBJ or TCINIT.OBJ are
       entries for the standard C memory handling routines. These
       should be noted carefully.

    þ  There is currently a problem when interfacing to C functions
       that returns floating numbers as the return value. PDC Prolog
       assumes that reals are returned in the registers AX, BX, CX,
       DX. Turbo C and Microsoft C returns reals on the co-processor
       stack.


General notes for linking under Windows, NT, OS/2 and Phar Lap
==============================================================

    þ  On these platforms it's much easier and safer to interface
       different languages and libraries, since memory is handled
       by the operating system.

    þ  Note that these platforms use the processor in Protected
       Mode, and the initialization modules are here PDCGROUP.OBJ
       It is important that these comes before the first Prolog
       module in the linking command due to segment ordering. The
       result of placing these after the first Prolog module will
       be problems when retracting database facts given in the
       source code.

    þ  As described for the DOS version there is a problem when
       interfacing to C functions that returns floating point
       numbers.


General notes for linking under UNIX
====================================

    þ  The UNIX version of PDC Prolog is built entirely upon the
       standard C library provided by UNIX, augmented by semi-
       standard routines found in specialized libraries. However,
       note that the order of the libraries can be quite
       important for proper operation. See the shell program
       cc_call in /usr/lib/PDCProlog for the correct order; this
       program is called by PDC Prolog when linking up an
       executable.

    þ  If you're unfamiliar with shell programs, consider
       gettting a good introductory book to UNIX. In the
       meantime, as a quick solution, you could try setting PDC
       Prolog's verbosity to maximum, and see what's on the
       command line to cc. However, by far the easiest is simply
       to let PDC Prolog handle all compilation, including that
       of C, assembler, and object files. To do this, all you
       have to do is to make a project file (see the Reference
       Guide for more information about projects), specifying in
       the project file all files that are part of the project;
       remember to put the proper extension on to the names of C
       (.c), assembler (.s or .asm), and object (.o) files. PDC
       Prolog will only compile Prolog source files; everything
       else is passed on to cc (through the cc_call program),
       which in turn compiles C files, passes assembler files on
       to the assembler, and finally links all the object files.

    þ  If you come from a DOS background and haven't worked with
       UNIX before, there's a number of things to notice and be
       aware of. The most immediate of these would be that
       command lines can be up to 5120 characters long (and hence
       supplementary input files are never used); program
       arguments are rarely positional and nearly always
       introduced by a minus-sign; if given incomplete
       information on the command line, utilities tend to produce
       an error-message and exit, rather than prompt for the
       missing information; wildcards (*, [ sets ]) are expanded
       by the shell _before_ the program is called.

    þ  The start-up files are initux.o and runcmainux.o for COFF
       executables, and initxx.o and runcmainxx.o for OMF (XENIX)
       executables. The init[ux]x.o file must be the first of
       your object files.


