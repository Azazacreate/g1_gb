include "exception\\cExceptionDump.ph"
include "exception\\cExceptionVpiUtilities.ph"
include "vpi.pre"

constants
    cExceptionVpiUtilities_MajorVersion = 0
    cExceptionVpiUtilities_MinorVersion = 1
    cExceptionVpiUtilities_VersionYear = 2000
    cExceptionVpiUtilities_VersionMonth = 9
    cExceptionVpiUtilities_VersionDate = 8

constants
    prologErrFileName = "prolog.err"

global domains
    FILE = dump
    
implement cExceptionVpiUtilities
    static facts - dumpFile
    	determ dumpFile(string FileName)
    
    clauses
        moduleInfo(
            cExceptionVpiUtilities_ModuleName,
            cExceptionVpiUtilities_MajorVersion,
            cExceptionVpiUtilities_MinorVersion,
            cExceptionVpiUtilities_VersionYear,
            cExceptionVpiUtilities_VersionMonth,
            cExceptionVpiUtilities_VersionDate).

    clauses
        clearOrContinue( ExceptionIdOrCode, AcceptedExceptions, 
                ModuleInfoPredicate, PredicateName, _Message
            ):-
            cException::clearOrContinue(ExceptionIdOrCode, AcceptedExceptions, 
                ModuleInfoPredicate, PredicateName).
        clearOrContinue(_, _, _, _, Message):-
            dlg_Error( Message ),
	        fail.

    clauses
        clearOrContinueException( ExceptionIdOrCode, AcceptedExceptions, 
                ModuleInfoPredicate, PredicateName, _Message
            ):-
            cException::clearOrContinueException(ExceptionIdOrCode, AcceptedExceptions, 
                ModuleInfoPredicate, PredicateName).
        clearOrContinueException(_, _, _, _, Message):-
            dlg_Error( Message ),
	        fail.


    clauses
        errorHandler(WinHandle, ExceptionIdOrCode) :-
            WindowHandle = cast(integer, WinHandle),
            trap(
                cException::continue(ExceptionIdOrCode, moduleInfo,
                   cExceptionVpiUtilities_error_errorHandlerCatch, cExceptionVpiUtilities_errorMsg_errorHandlerCatch,
                   [namedValue("WinHandle", integer(WindowHandle))]),
                _,
                fail).
        errorHandler(_WinHandle, _ExceptionIdOrCode) :-
    	    dumpFile(FileName),
    	    !,
            closefile(dump),
            openwrite(dump,FileName),
            writedevice(dump),
            cExceptionDump::writeDump(),
            closefile(dump).
        errorHandler(_WinHandle, _ExceptionIdOrCode) :-
            cExceptionDump::writeDump().

    clauses
        setFileNameForDump(FileName):-
    	    retractall(dumpFile(_)),
    	    FileName = "",
    	    !. %empty means no dump file.
        setFileNameForDump(FileName):-
    	    assert(dumpFile(FileName)).


endclass cExceptionVpiUtilities

% end
