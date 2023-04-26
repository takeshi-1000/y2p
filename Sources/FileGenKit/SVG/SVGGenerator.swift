import Data

public class SVGGenerator {
    private let views: [View]
    private let settings: Settings
    
    public init(views: [View], settings: Settings) {
        self.views = views
        self.settings = settings
    }
    
    public func generate() throws -> String {
        return """
<svg width="200" height="200">
  <rect x="0" y="0" width="200" height="200" fill="#FF0000" />
</svg>
"""
    }
}
