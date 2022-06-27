// Copyright © 2022 Andrew Lord.

func handleFatalError<ResultT>(block: () throws -> ResultT) throws -> ResultT {
    do {
        return try block()
    } catch let error as SharedHooksError {
        printer.printError(error)
        throw ExecutionError.failure
    } catch {
        printer.printError(.otherError(error))
        throw ExecutionError.failure
    }
}

func handleNonFatalError(block: () throws -> Void) {
    do {
        try block()
    } catch let error as SharedHooksError {
        printer.printError(error)
    } catch {
        printer.printError(.otherError(error))
    }
}
