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
        let contentWidth = calculateWidth()
        let contentHeight = calculateHeight()
                
        return """
<svg width="\(Int(contentWidth))" height="\(Int(contentHeight))" viewBox="0 0 \(Int(contentWidth)) \(Int(contentHeight))">
  <rect x="0" y="0" width="\(Int(contentWidth))" height="\(Int(contentHeight))" fill="#FFFFFF" />
  <rect x="0" y="0" width="\(Int(contentWidth / 2))" height="\(Int(contentHeight / 2))" fill="#FF0000" />
  <rect x="\(Int(contentWidth / 2))" y="\(Int(contentHeight / 2))" width="\(Int(contentWidth / 2))" height="\(Int(contentHeight / 2))" fill="#FF0000" />
</svg>
"""
    }
}
