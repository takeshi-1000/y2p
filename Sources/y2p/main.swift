import y2pCLI

do {
    try CLICommander.command()
    print("👍 Success created!")
} catch let error {
    print("⚡️Fail⚡️")
    if let errorStr = ErrorHandler.handle(error) {
        print(errorStr)
    }
}

