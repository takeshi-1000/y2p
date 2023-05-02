import Data
import Cocoa

class SVGObjectGenerator2 {
    private let columnViewsList: [ColumnViews]
    private let settings: Settings
    
    var svgObjectList: [SVGObjectType] {  _svgObjectList }
    private var _svgObjectList: [SVGObjectType] = []
    
    init(columnViewsList: [ColumnViews], settings: Settings) {
        self.columnViewsList = columnViewsList
        self.settings = settings
    }
    
    func generate() {
        let margin: Double = settings.margin
        let viewVerticalMargin: Double = settings.viewVerticalMargin
        let viewHorizontalMargin: Double = settings.viewHorizontalMargin
        let viewObjectSize: NSSize = settings.viewObjectSize
        
        appendSVGObject()
        
        columnViewsList.forEach { columnViews in
            columnViews.viewList.forEach { data in
                let view: View = data.value
                let lineNumber: Int = data.key
                                
                let x: Double = margin + (Double(columnViews.columnNumber) * (viewHorizontalMargin + viewObjectSize.width))
                let y: Double = margin + (Double(lineNumber) * (viewVerticalMargin + viewObjectSize.height))
                
                let fillColorStr: String = view.contentColor.isEmpty == false
                 ? view.contentColor
                 : settings.viewObjectColorStr
                let strokeColorStr: String = view.borderColor.isEmpty == false
                 ? view.borderColor
                 : settings.viewObjectBorderColorStr
                
                let rectSvg: SVGObjectType = .rect(x: x,
                                                   y: y,
                                                   width: viewObjectSize.width,
                                                   height: viewObjectSize.height,
                                                   fill: fillColorStr,
                                                   stroke: strokeColorStr)
                let textSvg: SVGObjectType = .text(x: x + 5,
                                                   y: y + 20,
                                                   fontSize: settings.viewObjectTextFontSize,
                                                   fill: settings.viewObjectTextColorStr,
                                                   value: view.nameData.key)
                
                if view.urlStr.isEmpty == false {
                    _svgObjectList.append(.url(urlStr: view.urlStr, rect: rectSvg, text: textSvg))
                } else {
                    _svgObjectList.append(rectSvg)
                    _svgObjectList.append(textSvg)
                }
            }
        }
        
        func appendSVGObject() {
            let sideMargin: Double = margin * 2
            let width: Double = {
                let objectWidth: Double = Double(columnViewsList.count) * viewObjectSize.width
                let objectBetweenMargin: Double = Double(columnViewsList.count - 1) * viewHorizontalMargin
                return objectWidth + objectBetweenMargin + sideMargin
            }()
            let height: Double = {
                let maxLineNumber = columnViewsList
                    .reduce(into: [Int]()) { partialResult, columnViews in
                        let maxLineNumber = columnViews.viewList.sorted(by: { $0.key > $1.key }).first?.key
                        if let _maxLineNumber = maxLineNumber {
                            partialResult.append(_maxLineNumber)
                        }
                    }
                    .max()
                
                let lineNumber = Double(maxLineNumber ?? 0) + 1 // lineNumberは0から始まるので
                let objectHeight: Double = lineNumber * viewObjectSize.height
                let objectBetweenMargin: Double = (lineNumber - 1) * viewVerticalMargin
                return objectHeight + objectBetweenMargin + sideMargin
            }()
            
            _svgObjectList.append(
                .svg(width: width, height: height)
            )
        }
    }
}
