import Data
import Cocoa

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
        
        let viewPositionCalculator = ViewPositionCalculator(views: views, settings: settings)
        viewPositionCalculator.calculate()
        
        let lineViews = viewPositionCalculator.lineViews
        var svgObjectList: [SVGObjectType] = [.svg(width: contentWidth, height: contentHeight)]
        
        parseViewsToSVGObject(views: views)
                
        func parseViewsToSVGObject(views: [View]) {
            views.forEach { view in
                let fillColor = view.contentColor.isEmpty == false
                  ? view.contentColor
                  : settings.viewObjectColorStr

                svgObjectList.append(
                    .rect(x: view.rect.origin.x,
                          y: view.rect.origin.y,
                          width: view.rect.width,
                          height: view.rect.height,
                          fill: fillColor,
                          stroke: "000000")
                )
                
                if view.views.isEmpty == false {
                    parseViewsToSVGObject(views: view.views)
                }
            }
        }
                
        lineViews.forEach { lineView in
            svgObjectList.append(
                .line(x1: lineView.startPoint.x,
                      y1: lineView.startPoint.y,
                      x2: lineView.endPoint.x,
                      y2: lineView.endPoint.y,
                      stroke: lineView.colorStr,
                      strokeWidth: settings.slashWidth)
            )
        }
        
        var svgStr = """
        """
        
        svgObjectList.forEach { svgObject in
            
            switch svgObject {
            case .svg(width: let width, height: let height):
                svgStr += """
<svg width="\(width)" height="\(height)" viewBox="0 0 \(width) \(height)" xmlns="http://www.w3.org/2000/svg">
"""
                svgStr += "\n"
            case .rect(x: let x, y: let y, width: let width, height: let height, fill: let fill, stroke: let stroke):
                svgStr += """
 <rect x="\(Int(x))" y="\(y)" width="\(width)" height="\(height)" fill="#\(fill)" stroke="#\(stroke)" />
"""
                svgStr += "\n"
            case .line(x1: let x1, y1: let y1, x2: let x2, y2: let y2, stroke: let stroke, strokeWidth: let strokeWidth):
                svgStr += """
 <line x1="\(x1)" y1="\(y1)" x2="\(x2)" y2="\(y2)" stroke="#\(stroke)" stroke-width="\(strokeWidth)" />
"""
                svgStr += "\n"
            case .text: break
            }
        }
        
        svgStr += "</svg>"
                
        print("====== svg text ======")
        
        print(svgStr)
        
        print("======================")
        return svgStr
    }
}
