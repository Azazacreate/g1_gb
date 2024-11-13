include "exception\\cException.ph"

constants % module Info
    cExceptionDump_ModuleName = "com/visual-prolog/cExceptionDump"

class cExceptionDump
    static predicates
        moduleInfo : cException::moduleInfoPredicate
    static predicates
        writeDump() - procedure ()
endclass cExceptionDump

% end
