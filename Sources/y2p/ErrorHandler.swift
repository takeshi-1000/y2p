import Foundation

enum ErrorHandler {
    static func handle(_ error: Error) -> String? {
        let errorStr: (_ cause: String, _ detail: String) -> String = { cause, detail in
            return "原因: \(cause)\n詳細: \(detail)"
        }
        
        switch error {
        case let error as NSError:
            if error._code == NSFileReadNoSuchFileError {
                return errorStr("Yamlファイルが見つかりませんでした", error.description)
            }
        }
        
        return nil
    }
}
