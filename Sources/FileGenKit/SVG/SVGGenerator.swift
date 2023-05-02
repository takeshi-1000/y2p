import Data
import Cocoa

public class SVGGenerator: FileGeneratable {
    typealias Content = String
    let views: [View]
    let settings: Settings
    
    private var shouldDump: Bool = false
    
    required public init(views: [View], settings: Settings) {
        self.views = views
        self.settings = settings
    }
    
    public func generate() throws -> String? {
        let columnViewsGenerator = ColumnViewsGenerator()
        columnViewsGenerator.generate(views: views)
        let columnViewsList = columnViewsGenerator.columnViewsList
        
        let svgObjectGenerator2 = SVGObjectGenerator2(columnViewsList: columnViewsList, settings: settings)
        svgObjectGenerator2.generate()
        let svgObjectList: [SVGObjectType] = svgObjectGenerator2.svgObjectList
        
        var svgStr = """
        """
        
        svgObjectList.forEach { svgObject in
            
            switch svgObject {
            case .svg(width: let width, height: let height):
                svgStr += """
<svg width="\(width)" height="\(height)" viewBox="0 0 \(width) \(height)" xmlns="http://www.w3.org/2000/svg">
 <!-- 下記矢印の参照のための要素 -->
 <defs>
   <marker id="arrow" viewBox="0 0 10 10" refX="10" refY="5" markerWidth="6" markerHeight="6">
     <path d="M 0 0 L 10 5 L 0 10 z" />
   </marker>
 </defs>
"""
                svgStr += "\n"
            case .rect(x: let x, y: let y, width: let width, height: let height, fill: let fill, stroke: let stroke):
                svgStr += """
 <rect x="\(x)" y="\(y)" width="\(width)" height="\(height)" fill="#\(fill)" stroke="#\(stroke)" />
"""
                svgStr += "\n"
            case .line(x1: let x1, y1: let y1, x2: let x2, y2: let y2, stroke: let stroke, strokeWidth: let strokeWidth, let isMarker):
                if isMarker {
                    svgStr += """
 <line x1="\(x1)" y1="\(y1)" x2="\(x2)" y2="\(y2)" stroke="#\(stroke)" stroke-width="\(strokeWidth)" marker-end="url(#arrow)" />
"""
                } else {
                    svgStr += """
 <line x1="\(x1)" y1="\(y1)" x2="\(x2)" y2="\(y2)" stroke="#\(stroke)" stroke-width="\(strokeWidth)" />
"""
                }
                svgStr += "\n"
            case .text(x: let x, y: let y, fontSize: let fontSize, fill: let fill, value: let value):
                svgStr += """
 <text x="\(x)" y="\(y)" font-size="\(fontSize)" fill="#\(fill)">\(value)</text>
"""
                svgStr += "\n"
            case .url(urlStr: let urlStr, rect: let svgRect, text: let svgText):
                var _svgStr = ""
                
                // URL
                _svgStr += """
 <a href="\(urlStr)">
"""
                _svgStr += "\n"
                
                // Rect
                if case .rect(x: let x,
                              y: let y,
                              width: let width,
                              height: let height,
                              fill: let fill,
                              stroke: let stroke) = svgRect {
                    _svgStr += """
  <rect x="\(x)" y="\(y)" width="\(width)" height="\(height)" fill="#\(fill)" stroke="#\(stroke)" />
"""
                    _svgStr += "\n"
                }
                
                // Text
                if case .text(x: let x,
                              y: let y,
                              fontSize: let fontSize,
                              fill: _,
                              value: let value) = svgText {
                    _svgStr += """
  <text x="\(x)" y="\(y)" font-size="\(fontSize)" fill="blue">\(value)</text>
"""
                    _svgStr += "\n"
                }
                _svgStr += """
 </a>
"""
                svgStr += _svgStr
                svgStr += "\n"
            }
        }
        
        svgStr += "</svg>"
        
        if shouldDump {
            print("====== svg text ======")
            
            print(svgStr)
            
            print("======================")
        }
        
        return svgStr
    }
}

extension SVGGenerator {
    public func updateShouldDump(_ shouldDump: Bool) {
        self.shouldDump = shouldDump
    }
}
