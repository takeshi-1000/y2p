import Data
import Foundation
import YamlParserKit
import FileGenKit

public class CLI {
    public static func execute() throws {
        // parse commandLine arguments
        let commandLineArgParser = CommandLineArgParser()
        commandLineArgParser.parse(arguments: CommandLine.arguments)
        let yamlFileNameStr = commandLineArgParser.yamlfileNameStr
        let fileNameStr = commandLineArgParser.fileNameStr
        let dump: Bool = commandLineArgParser.dump
        
        // parse yaml
        let yamlParser = YamlParser()
        try yamlParser.parse(fileURL: URL(fileURLWithPath: yamlFileNameStr))
        let views: [View] = yamlParser.views
        let settings: Settings = yamlParser.settings
        
        let svgGenerator = SVGGenerator(views: views, settings: settings)
        svgGenerator.updateShouldDump(dump)
        let svgStr = try svgGenerator.generate()
        try svgStr?.write(to: URL(fileURLWithPath: fileNameStr), atomically: true, encoding: .utf8)
    }
}
