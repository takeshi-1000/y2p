enum CLIMode {
    case image
    case svg
}

class CommandLineArgParser {
    var yamlfileNameStr: String { _yamlfileNameStr }
    var fileNameStr: String { _fileNameStr }
    var mode: CLIMode { _mode }
    
    private var _yamlfileNameStr: String = "y2p.yaml"
    private var _fileNameStr: String = "transition.png"
    private var _mode: CLIMode = .image
    
    func parse(arguments: [String]) {
        if let fileNameOptionIndex = CommandLine.arguments.firstIndex(of: "-fileName") {
            let fileNameStrIndex = CommandLine.arguments.index(after: fileNameOptionIndex)
            _yamlfileNameStr = arguments[fileNameStrIndex]
        }
        
        if let fileNameObjectOptionIndex = CommandLine.arguments.firstIndex(of: "-o") {
            let fileNameObjectStrIndex = CommandLine.arguments.index(after: fileNameObjectOptionIndex)
            _fileNameStr = arguments[fileNameObjectStrIndex]
            
            if _fileNameStr.hasSuffix(".svg") {
                _mode = .svg
            } else {
                _mode = .image
            }
        }
    }
}
