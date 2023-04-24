import Data
import Foundation
import YamlParserKit
import ImageGenKit

public class CLICommander {
    public static func command() throws {
        let fileURL = URL(fileURLWithPath: "y2p.yml")
        let yamlParser = YamlParser()
        try yamlParser.parse(fileURL: fileURL)
        
        let views: [View] = yamlParser.views
        let settings: Settings = yamlParser.settings
        
        let imageGenerator = ImageGenerator(views: views, settings: settings)
        let imageData = try imageGenerator.generate()
        
        try? imageData?.write(to: URL(fileURLWithPath: settings.imageName))
    }
}
