class CommandLineArgParser {
    var yamlfileNameStr: String { _yamlfileNameStr }
    var fileNameStr: String { _fileNameStr }
    var dump: Bool { _dump }
    
    private var _yamlfileNameStr: String = "y2p.yaml"
    private var _fileNameStr: String = "screen_transition_diagram.svg"
    private var _dump: Bool = false
    
    func parse(arguments: [String]) {
        if let fileNameOptionIndex = arguments.firstIndex(of: "-fileName") {
            let fileNameStrIndex = arguments.index(after: fileNameOptionIndex)
            _yamlfileNameStr = arguments[fileNameStrIndex]
        }
        
        if let fileNameObjectOptionIndex = arguments.firstIndex(of: "-o") {
            let fileNameObjectStrIndex = arguments.index(after: fileNameObjectOptionIndex)
            _fileNameStr = arguments[fileNameObjectStrIndex]
        }
        
        if arguments.firstIndex(of: "-dump") != nil || arguments.firstIndex(of: "-d") != nil {
            _dump = true
        }
    }
}
