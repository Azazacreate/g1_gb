/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

				Visual Prolog

 Project:
 FileName: cException.pro
 Purpose: Exception handling system 
 Written by: Thomas Linder Puls
 Comments: Exception handling system implementation

******************************************************************************/
errorlevel = 0
% errorlevel must be zero in this ModuleInfoPredicate to let positions refer to "caller" positions.

include "exception\\cException.ph"

constants % ModuleInfoPredicate Info
    cException_MajorVersion = 0
    cException_MinorVersion = 1
    cException_VersionYear = 2000
    cException_VersionMonth = 4
    cException_VersionDate = 11

constants
    prologErrorFileName = "prolog.err"

implement cException
    clauses
        moduleInfo(
            cException_ModuleName,
            cException_MajorVersion,
            cException_MinorVersion,
            cException_VersionYear,
            cException_VersionMonth,
            cException_VersionDate).

        unknownModuleInfo(
            cException_unknownModuleName,
            cException_unknownMajorVersion,
            cException_unknownMinorVersion,
            cException_unknownVersionYear,
            cException_unknownVersionMonth,
            cException_unknownVersionDate).

    % begin exception Id sequence
    static facts - cException_id
        single nextId_db(exceptionId Next)
    clauses
        nextId_db(firstTraceId).

    static predicates
        exceptionId getNextId()
        - procedure ()
    clauses
        getNextId(Next) :-
            nextId_db(Next),
            NewNext = Next+1,
            assert(nextId_db(NewNext)).
    % end exception Id sequence
    
    % begin exceptionIds
    static predicates
        isTraceId(exceptionId ExceptionIdOrCode) 
        - determ (i)
    clauses
        isTraceId(TraceId) :-
            TraceId >= firstTraceId.
    % end exceptionIds

    % begin create descriptor
    static predicates
        descriptor createDescriptor(
            exceptionId ExceptionId,
            moduleInfoPredicate ModuleInfoPredicate,
            errorCode ErrorCode,
            string Description,
            cValue::namedValue_list ExtraInfo,
            kind Kind)
        - procedure (i,i,i,i,i,i)
        timeStamp getTimeStamp()
        - procedure ()
        position getPosition(kind Kind, exceptionId ExceptionId)
        - procedure (i,i)
    clauses
        createDescriptor(ExceptionId, ModuleInfoPredicate, ErrorCode, Description, ExtraInfo, Kind, Descriptor) :-
            TimeStamp = getTimeStamp(),
            Position = getPosition(Kind, ExceptionId),
            Descriptor = descriptor(ExceptionId, ModuleInfoPredicate, ErrorCode, Description, ExtraInfo,
                 Kind, TimeStamp, Position).
                 
             getTimeStamp(timeStamp(Year, Month, Day, Hours, Minutes, Seconds, HS)) :-
                 date(Year, Month, Day),
                 time(Hours, Minutes, Seconds, HS).

            % this predicate performs an errorexit that that make sure Position is set to the caller
            % it only work properly if invoked in a ModuleInfoPredicate with "errorlevel = 0" (see top of file)
            getPosition(Kind, ExceptionId, _) :-
                not(Kind = externalKind()),
                trap(errorexit(ExceptionId), _, fail).
            getPosition(_Kind, _ExceptionId, position(FileName, IncludeFile, Position)) :-
                lasterror(_, FileName, IncludeFile, Position).
    % end create descriptor

    % begin exception trace database
    static facts - traces
        descriptor_db(descriptor Descriptior)
  
    static predicates
        assertDescriptor(
            exceptionId ExceptionId,
            moduleInfoPredicate ModuleInfoPredicate,
            errorCode ErrorCode,
            string Description,
            cValue::namedValue_list ExtraInfo,
            kind Kind)
        - procedure (i,i,i,i,i,i)
        exceptionId getLastExceptionId()
        - procedure ()
    clauses
        % LIFO
        assertDescriptor(ExceptionId, ModuleInfoPredicate, ErrorCode, Description, ExtraInfo, Kind) :-
            Descriptor = createDescriptor(ExceptionId, ModuleInfoPredicate, ErrorCode, Description, ExtraInfo, Kind),
            asserta(descriptor_db(Descriptor)).

        getLastExceptionId(LastId) :-
            descriptor_db(descriptor(LastId, _ModuleInfoPredicate, _ErrorCode, _Description, _ExtraInfo, _Kind, _TimeStamp, _Position)),
            !.
        getLastExceptionId(0).

    % internal exception predicates
    static predicates
        raiseNonLast(exceptionId ExceptionId) - erroneous (i)
    clauses
        raiseNonLast(ExceptionId) :-
            raise(moduleInfo, cException_error_nonLast, cException_errorMsg_nonLast,
                [namedValue(cException_field_id, integer(ExceptionId))]).


    % clear exception
    clauses
        clear(ExceptionId) :-
            ExceptionId = getLastExceptionId(),
            !,
            retractAll(descriptor_db(descriptor(ExceptionId, _, _, _, _, _, _, _))).
        clear(ExceptionId) :-
            raiseNonLast(ExceptionId).

    %clear state
    clauses
        clearExceptionState() :-
           retractAll(_, traces).

    % begin external error
    static predicates
        externalError(exceptionId ExceptionIdOrCode, exceptionId ExceptionId) - procedure (i,o)

        externalExtraInfo(
            errorCode TrapCode,
            string HelpString,
            cValue::namedValue_list ErrorList)
        - procedure (i,o,o)

         descriptor createExternalDescriptor(exceptionId ExceptionId, exceptionId Code)
        - procedure (i,i)
    clauses
        externalError(Code, ExceptionId) :-
            not(isTraceId(Code)),
            !,
            ExceptionId = getNextId(),
            Descriptor = createExternalDescriptor(ExceptionId, Code),
            assert(descriptor_db(Descriptor)).
        externalError(ExceptionId, ExceptionId).

        externalExtraInfo(TrapCode, Help, ErrorList) :-
            errormsg(prologErrorFileName, TrapCode, Help, EHelp),
            !,
            ErrorList =
                [namedValue(cException_field_code, integer(TrapCode)),
                 namedValue(cException_field_help, string(Help)),
                 namedValue(cException_field_description,string(EHelp))].
        externalExtraInfo(_TrapCode, cException_errorMsg_UnknownError, []).
    % end external error

    % interrogate the exception state
    clauses
        % check for certain exception
        getDescriptor_det(ExceptionId, unknownModuleInfo, Code, Descriptor) :-
            Code = cast(errorCode, ExceptionId),
            !,
            Descriptor = createExternalDescriptor(ExceptionId, ExceptionId).
        getDescriptor_det(ExceptionId, ModuleInfoPredicate, Code, Descriptor) :-
            descriptor_db(Descriptor),
            Descriptor = descriptor(ExceptionId, ModuleInfoPredicate, Code, _, _, _, _, _),
            !.
            
       createExternalDescriptor(ExceptionId, Code, Descriptor) :-
            TrapCode = cast(errorCode, Code),
            externalExtraInfo(TrapCode, Help, ErrorList),
            Descriptor = createDescriptor(ExceptionId, unknownModuleInfo, TrapCode, Help, ErrorList, externalKind()).
 
        % get a whole exception trace
        getDescriptor_nd(ExceptionId, Descriptor) :-
            descriptor_db(Descriptor),
            Descriptor = descriptor(ExceptionId, _, _, _, _, _, _, _).

        % get an exception trace, filtedred for a specific ModuleInfoPredicate.
        % I.e. get those entries in a certain trace that relates to a certain ModuleInfoPredicate
        getDescriptor_nd(ExceptionId, ModuleInfoPredicate, Descriptor) :-
            descriptor_db(Descriptor),
            Descriptor = descriptor(ExceptionId, ModuleInfoPredicate, _, _, _, _, _, _).

        % get the whole exception state, i.e. all traces.
        getAllTraces_nd(Descriptor) :-
            descriptor_db(Descriptor).
    % end exception trace database


    % begin raise exception
    clauses
        raise(ModuleInfoPredicate, Code, Description) :-
            raise(ModuleInfoPredicate, Code, Description, []).
        
        raise(ModuleInfoPredicate, Code, Description, ExtraInfo) :-
            ExceptionId = getNextId(),
            assertDescriptor(ExceptionId, ModuleInfoPredicate, Code, Description, ExtraInfo, raiseKind()),
            exit(ExceptionId).
    % end raise exception

    % begin continue/reraise exception
    static predicates
        checkForNonLast(exceptionId LastExceptionId, exceptionId ExceptionId) - erroneous (i,i)
    clauses
        checkForNonLast(ExceptionId, ExceptionId) :-
            !,
            exit(ExceptionId).
        checkForNonLast(_LastExceptionId, ExceptionId) :-
            raiseNonLast(ExceptionId).
            
        continue(ExceptionIdOrCode, ModuleInfoPredicate, Code, Description) :-
            continue(ExceptionIdOrCode, ModuleInfoPredicate, Code, Description, []).

        continue(ExceptionIdOrCode, ModuleInfoPredicate, Code, Description, ExtraInfo) :-
            externalError(ExceptionIdOrCode, ExceptionId),
            LastExceptionId = getLastExceptionId(),
            assertDescriptor(ExceptionId, ModuleInfoPredicate, Code, Description, ExtraInfo, continueKind()),
            checkForNonLast(LastExceptionId, ExceptionId).
            
        continue(ExceptionId) :-
            LastExceptionId = getLastExceptionId(),
            checkForNonLast(LastExceptionId, ExceptionId).
    % end continue/reraise exceptio

    static predicates
        clearOrContinueException_pr(
            exceptionId ExceptionIdOrCode,
            moduleException_list AcceptedExceptions,
            moduleInfoPredicate ModuleInfoPredicate,
            string PredicateName)
        - procedure (i,i,i,i)
    clauses
        clearOrContinueException_pr(TrapCode, [],  ModuleInfoPredicate, PredicateName) :-
            continue(TrapCode, ModuleInfoPredicate, generic_error_unexpected, generic_errorMsg_unexpected,
                [namedValue(generic_field_predicate, string(PredicateName))]).
        clearOrContinueException_pr(TrapCode, [ex(unknownModuleInfo,Code)|_ExList], 
                _ModuleInfoPredicate, _PredicateName) :-
            TrapCode = cast(exceptionId, Code),
            !.  % exception is accepted, and since it is never raised it should not be cleared.
        clearOrContinueException_pr(TrapCode, [ex(ModuleInfo,Code)|_ExList], 
                _ModuleInfoPredicate, _PredicateName) :-
            _Descriptor = getDescriptor_det(TrapCode, ModuleInfo, Code),
            !,
            clear(TrapCode).
        clearOrContinueException_pr(TrapCode, [_Ex|ExList], ModuleInfoPredicate, PredicateName) :-
            clearOrContinueException_pr(TrapCode, ExList, ModuleInfoPredicate, PredicateName).
            
    static predicates
        toModuleException_list(errorCode_list CodeList, moduleException_list ExList)
        - procedure (i,o)
    clauses
        toModuleException_list([], []).
        toModuleException_list([Code|CodeList], [ex(unknownModuleInfo,Code)|ExList]) :-
            toModuleException_list(CodeList, ExList).

    clauses
        clearOrContinue(TrapCode, AcceptedList,  ModuleInfoPredicate, PredicateName) :-
            toModuleException_list(AcceptedList, ModuleExceptionList),
            clearOrContinueException(TrapCode, ModuleExceptionList,  ModuleInfoPredicate, PredicateName).

    clauses
        % safer to implement a procedure
        clearOrContinueException(TrapCode, ExList, ModuleInfoPredicate, PredicateName) :-
            not(clearOrContinueException_pr(TrapCode, ExList, ModuleInfoPredicate, PredicateName)).
            
            
    % end check accepted exception

endclass cException