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
        appendSVGLineObject()
        appendSVGRectObject()
        
        func appendSVGRectObject() {
            columnViewsList.forEach { columnViews in
                columnViews.viewList.forEach { data in
                    let view: View = data.view
                    let lineNumber: Int = data.lineNumber
                                    
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
        }
        
        func appendSVGLineObject() {
            for columnViews in columnViewsList {
                let columnNumber: Double = Double(columnViews.columnNumber)
                if columnNumber == 0 {
                    continue
                }
                
                columnViews.viewList.forEach { viewInfo in
                    let y: Double = margin + ((viewObjectSize.height + viewVerticalMargin) * Double(viewInfo.lineNumber)) + (viewObjectSize.height / 2)
                    let x2: Double = margin + ((viewObjectSize.width + viewHorizontalMargin) * columnNumber)
                    
                    let x1: Double = {
                        if viewInfo.transitionData.number == 0 {
                            return x2 - viewHorizontalMargin
                        } else {
                            return x2 - (viewHorizontalMargin / 2)
                        }
                    }()
                    
                    _svgObjectList.append(
                        .line(x1: x1,
                              y1: y,
                              x2: x2,
                              y2: y,
                              stroke: "000000",
                              strokeWidth: settings.lineWidth,
                              isMarker: true)
                    )
                    
                    // 縦線
                    if viewInfo.transitionData.number == 0 {
                        let key = viewInfo.transitionData.sourceViewKey
                        let filterViewInfoList = columnViews.viewList
                            .filter { $0.transitionData.sourceViewKey == key }
                        
                        if filterViewInfoList.count > 1,
                           let endLineNumber = filterViewInfoList.sorted(by: { $0.lineNumber > $1.lineNumber }).first?.lineNumber {
                               let x = x2 - (viewHorizontalMargin / 2)
                               let y1: Double = y
                               let y2: Double = margin + ((viewObjectSize.height + viewVerticalMargin) * Double(endLineNumber)) + (viewObjectSize.height / 2)
                               
                               _svgObjectList.append(
                                .line(x1: x,
                                      y1: y1,
                                      x2: x,
                                      y2: y2,
                                      stroke: "000000",
                                      strokeWidth: settings.lineWidth,
                                      isMarker: false)
                               )
                           }
                    }
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
                        let maxLineNumber = columnViews.viewList
                            .sorted(by: { $0.lineNumber > $1.lineNumber })
                            .first?.lineNumber
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
