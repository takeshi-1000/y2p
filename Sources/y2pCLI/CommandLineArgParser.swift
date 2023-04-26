enum CLIMode {
    case image
    case svg
}

class CommandLineArgParser {
    var fileNameStr: String { _fileNameStr }
    var mode: CLIMode { _mode }
    
    private var _fileNameStr: String = "y2p.yaml"
    private var _mode: CLIMode = .image
    
    func parse(arguments: [String]) {
        if let fileNameOptionIndex = CommandLine.arguments.firstIndex(of: "-fileName") {
            let fileNameStrIndex = CommandLine.arguments.index(after: fileNameOptionIndex)
            _fileNameStr = arguments[fileNameStrIndex]
        }
        
        if let modeOptionIndex = CommandLine.arguments.firstIndex(of: "-mode") {
            let modeStrIndex = CommandLine.arguments.index(after: modeOptionIndex)
            let modeStr = arguments[modeStrIndex]
            
            switch modeStr {
            case "image":
                _mode = .image
            case "svg":
                _mode = .svg
            default: break
            }
        }
    }
}
