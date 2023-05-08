import Data
import Foundation
import YamlParserKit
import FileGenKit

public class CLI {
    public static func execute() throws {
        // parse commandLine arguments
        let commandLineArgParser = CommandLineArgParser()
        commandLineArgParser.parse(arguments: CommandLine.arguments)
        let mode = commandLineArgParser.mode
        let yamlFileNameStr = commandLineArgParser.yamlfileNameStr
        let fileNameStr = commandLineArgParser.fileNameStr
        let dumpSVG: Bool = commandLineArgParser.dumpSVG
        let shouldAddHelperLine: Bool = commandLineArgParser.shouldAddHelperLine
        
        // parse yaml
        let yamlParser = YamlParser()
        try yamlParser.parse(fileURL: URL(fileURLWithPath: yamlFileNameStr))
        let views: [View] = yamlParser.views
        let settings: Settings = yamlParser.settings
        
        // generate some file
        switch mode {
        case .image:
            let imageGenerator = ImageGenerator(views: views, settings: settings)
            let imageData = try imageGenerator.generate()
            try? imageData?.write(to: URL(fileURLWithPath: fileNameStr))
        case .svg:
            let svgGenerator = SVGGenerator(views: views, settings: settings)
            svgGenerator.updateShouldDump(dumpSVG)
            svgGenerator.updateShouldEmitSeparatedLine(shouldAddHelperLine)
            let svgStr = try svgGenerator.generate()
            try svgStr?.write(to: URL(fileURLWithPath: fileNameStr), atomically: true, encoding: .utf8)
        }
    }
}
