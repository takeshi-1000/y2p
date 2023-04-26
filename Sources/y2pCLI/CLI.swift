import Data
import Foundation
import YamlParserKit
import ImageGenKit
import SVGGenKit

public class CLI {
    public static func execute() throws {
        let commandLineArgParser = CommandLineArgParser()
        commandLineArgParser.parse(arguments: CommandLine.arguments)
        
        let mode = commandLineArgParser.mode
        let fileNameStr = commandLineArgParser.fileNameStr
        
        let yamlParser = YamlParser()
        try yamlParser.parse(fileURL: URL(fileURLWithPath: fileNameStr))
        
        let views: [View] = yamlParser.views
        let settings: Settings = yamlParser.settings
        
        switch mode {
        case .image:
            let imageGenerator = ImageGenerator(views: views, settings: settings)
            let imageData = try imageGenerator.generate()
            
            try? imageData?.write(to: URL(fileURLWithPath: settings.imageName))
        case .svg:
            let svgGenerator = SVGGenerator(views: views, settings: settings)
            // TODO: SVG出力
            let _ = try svgGenerator.generate()
            break
        }
    }
}
