import Data

public class SVGGenerator: FileGeneratable {
    typealias Content = String
    let views: [View]
    let settings: Settings
    
    required public init(views: [View], settings: Settings) {
        self.views = views
        self.settings = settings
    }
    
    public func generate() throws -> String? {
        return """
<svg width="200" height="200">
  <rect x="0" y="0" width="200" height="200" fill="#FF0000" />
</svg>
"""
    }
}
