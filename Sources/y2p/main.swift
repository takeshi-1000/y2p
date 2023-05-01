import y2pCLI

do {
    try CLI.execute()
    print("👍 Success created!")
} catch let error {
    print("⚡️Fail⚡️")
    print(ErrorHandler.handle(error))
}

