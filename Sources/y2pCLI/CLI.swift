import Data
import Foundation
import YamlParserKit
import ImageGenKit

public class CLI {
    public static func execute() throws {        
        let fileURL: URL = {
            if let index = CommandLine.arguments.firstIndex(of: "-fileName") {
                let fileNameStrIndex = CommandLine.arguments.index(after: index)
                return URL(fileURLWithPath: CommandLine.arguments[fileNameStrIndex])
            } else {
                return URL(fileURLWithPath: "y2p.yaml")
            }
        }()
        
        let yamlParser = YamlParser()
        try yamlParser.parse(fileURL: fileURL)
        
        let views: [View] = yamlParser.views
        let settings: Settings = yamlParser.settings
        
        let imageGenerator = ImageGenerator(views: views, settings: settings)
        let imageData = try imageGenerator.generate()
        
        try? imageData?.write(to: URL(fileURLWithPath: settings.imageName))
    }
}
