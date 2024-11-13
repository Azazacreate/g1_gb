include "vpi.dom"
include "exception\\cException.ph"

constants % module Info
    cExceptionVpiUtilities_ModuleName = "com/visual-prolog/cExceptionVpiUtilities"

constants
    cExceptionVpiUtilities_error_errorHandlerCatch = 1
    cExceptionVpiUtilities_errorMsg_errorHandlerCatch = "Error handler catched an error"

class cExceptionVpiUtilities
    static predicates
        moduleInfo : cException::moduleInfoPredicate

    static predicates
        errorHandler : errHandler

    static predicates
        clearOrContinue(
            cException::exceptionId ExceptionIdOrCode,
            cException::errorCode_list AcceptedExceptions,
            cException::moduleInfoPredicate ModuleInfoPredicate,
            string PredicateName,
            string DialogMessage)
        - failure (i,i,i,i,i)

    static predicates
        clearOrContinueException(
            cException::exceptionId ExceptionIdOrCode,
            cException::moduleException_list AcceptedExceptions,
            cException::moduleInfoPredicate ModuleInfoPredicate,
            string PredicateName,
            string DialogMessage)
        - failure (i,i,i,i,i)

    static predicates
        setFileNameForDump(string FileName) - procedure (i)

endclass cExceptionVpiUtilities

% end
