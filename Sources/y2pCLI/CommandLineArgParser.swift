enum CLIMode {
    case image
    case svg
}

class CommandLineArgParser {
    var yamlfileNameStr: String { _yamlfileNameStr }
    var fileNameStr: String { _fileNameStr }
    var mode: CLIMode { _mode }
    var dumpSVG: Bool { _dumpSVG }
    
    private var _yamlfileNameStr: String = "y2p.yaml"
    private var _fileNameStr: String = "screen_transition_diagram.svg"
    /// The output format (SVG or image) is determined by the file name
    /// default file name is "transition.png", so output format is image
    private var _mode: CLIMode = .svg
    /// dump parameter is only for svg
    private var _dumpSVG: Bool = false
    
    func parse(arguments: [String]) {
        if let fileNameOptionIndex = arguments.firstIndex(of: "-fileName") {
            let fileNameStrIndex = arguments.index(after: fileNameOptionIndex)
            _yamlfileNameStr = arguments[fileNameStrIndex]
        }
        
        if let fileNameObjectOptionIndex = arguments.firstIndex(of: "-o") {
            let fileNameObjectStrIndex = arguments.index(after: fileNameObjectOptionIndex)
            _fileNameStr = arguments[fileNameObjectStrIndex]
            
            if _fileNameStr.hasSuffix(".svg") {
                _mode = .svg
            } else {
                _mode = .image
            }
        }
        
        if arguments.firstIndex(of: "-dump") != nil || arguments.firstIndex(of: "-d") != nil {
            _dumpSVG = true
        }
    }
}
