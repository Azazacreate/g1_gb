include "exception\\cExceptionDump.ph"

constants
    cExceptionDump_MajorVersion = 0
    cExceptionDump_MinorVersion = 1
    cExceptionDump_VersionYear = 2000
    cExceptionDump_VersionMonth = 4
    cExceptionDump_VersionDate = 12

constants
    dateSeparator ="-"
    timeSeparator = ":"
    dumpDivider = "\n============================\n"
    descriptionDivider = "------------------------------\n"
    extraInfoIndent = "    "

implement cExceptionDump
    clauses
        moduleInfo(
            cExceptionDump_ModuleName,
            cExceptionDump_MajorVersion,
            cExceptionDump_MinorVersion,
            cExceptionDump_VersionYear,
            cExceptionDump_VersionMonth,
            cExceptionDump_VersionDate).

    static predicates
        cException::timeStamp getTimeStamp()
        - procedure ()
    clauses
         getTimeStamp(timeStamp(Year, Month, Day, Hours, Minutes, Seconds, HS)) :-
             date(Year, Month, Day),
             time(Hours, Minutes, Seconds, HS).
    static predicates
        write2(integer Number) - procedure (i)
    clauses
        write2(Number) :-
            Number <= 9,
            Number >= 0,
            !,
            write(0, Number).
        write2(Number) :-
            write(Number).

    static predicates
        writeTimeStamp(cException::timeStamp TimeStamp) - procedure (i)
        writeDate(integer Year, integer Month, integer Day) - procedure (i,i,i)
        writeTime(integer Hours, integer Minutes, integer Seconds, integer HS) - procedure (i,i,i,i)
   clauses
        writeTimeStamp(timeStamp(Year, Month, Day, Hours, Minutes, Seconds, HS)) :-
            writeDate(Year, Month, Day),
             write(" "),
             writeTime(Hours, Minutes, Seconds, HS).

        writeDate(Year, Month, Day) :-
             write(Year),
             write(dateSeparator),
             write2(Month),
             write(dateSeparator),
             write2(Day).

         writeTime(Hours, Minutes, Seconds, HS) :-
             write2(Hours),
             write(timeSeparator),
             write2(Minutes),
             write(timeSeparator),
             write2(Seconds),
             write(timeSeparator),
             write2(HS).

    static predicates
        writeModuleInfo(cException::moduleInfoPredicate ModuleInfoPredicate) - procedure (i)
    clauses
        writeModuleInfo(ModuleInfoPredicate) :-
            ModuleInfoPredicate(ModuleName, MajorVersion, MinorVersion, Year, Month, Date),
            write("Module: ", ModuleName, " version ", MajorVersion, ".", MinorVersion),
            write(" ("),
            writeDate(Year, Month, Date),
            write(")").

    static predicates
        writePosition(cException::position Position) - procedure (i)
        writeFileName(string FileName) - procedure (i)
    clauses
        writePosition(position(FileName, IncludeFile, Position)) :-
            write("Module:"),
            writeFileName(FileName),
            writeFileName(IncludeFile),
            write("Pos:", Position, " M").

        writeFileName("") :-
            !.
        writeFileName(FileName) :-
            write(FileName, " ").

    static predicates
        writeExtraInfo(cValue::namedValue_list ExtraInfo) - procedure (i)
        writeNamedValue(cValue::namedValue NamedValue) - procedure (i)
        writeValue(cValue::value NamedValue) - procedure (i)
    clauses
        writeExtraInfo([]).
        writeExtraInfo([NamedValue|NamedValueL]) :-
            write(extraInfoIndent), writeNamedValue(NamedValue), nl,
            writeExtraInfo(NamedValueL).
            
        writeNamedValue(namedValue(Name, Value)) :-
            write(Name, " = "), writeValue(Value).

        writeValue(integer(Value)) :-
            write(Value).
        writeValue(real(Value)) :-
            write(Value).
        writeValue(long(Value)) :-
            write(Value).
        writeValue(string(Value)) :-
            write(Value).
        writeValue(null_value) :-
            write("null").

    static predicates
        writeDescriptor(cexception::descriptor Descriptor) - procedure (i)
    clauses
        writeDescriptor(descriptor(ExceptionId,  ModuleInfoPredicate,  ErrorCode,
                Description, ExtraInfo, Kind, TimeStamp, Position)) :-
            write(descriptionDivider),
            write(Kind), nl,
            write("Id: ", ExceptionId), nl,
            writeTimeStamp(TimeStamp), nl,
            writeModuleInfo(ModuleInfoPredicate), nl,
            writePosition(Position), nl,
            write(ErrorCode, " ", Description), nl,
            writeExtraInfo(ExtraInfo).

    static predicates
        writeAllTraces() - procedure ()
    clauses
        writeAllTraces() :-
            Descriptor = cException::getAllTraces_nd(),
                writeDescriptor(Descriptor),
            fail.
        writeAllTraces().
        
    clauses
        writeDump() :-
            write(dumpDivider),
            TimeStamp = getTimeStamp(),
            write("Dump: "), writeTimeStamp(TimeStamp), nl,
            writeAllTraces().

endclass cExceptionDump

% end
