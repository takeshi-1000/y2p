import y2pCLI

do {
    try CLI.execute()
    print("👍 Success created!")
} catch let error {
    print("⚡️Fail⚡️")
    if let errorStr = ErrorHandler.handle(error) {
        print(errorStr)
    }
}

