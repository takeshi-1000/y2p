import Data
import Cocoa

class SVGObjectGenerator {
    private let columnViewsList: [ColumnViews]
    private let settings: Settings
    
    var svgObjectList: [SVGObjectType] {  _svgObjectList }
    private var _svgObjectList: [SVGObjectType] = []
    
    init(columnViewsList: [ColumnViews], settings: Settings) {
        self.columnViewsList = columnViewsList
        self.settings = settings
    }
    
    private var margin: Double { settings.margin }
    private var viewVerticalMargin: Double { settings.viewVerticalMargin }
    private var viewHorizontalMargin: Double { settings.viewHorizontalMargin }
    private var viewObjectSize: NSSize { settings.viewObjectSize }
    
    var separatedViews: [ColumnViewInfo] {
        columnViewsList
            .first { $0.columnNumber == 0 }?
            .viewList.filter { $0.view.isRoot == false } ?? []
    }
    
    func generate(shouldEmitSeparatedLine: Bool) {
        
        appendSVGObject()
        appendSVGLineObject(shouldEmitSeparatedLine: shouldEmitSeparatedLine)
        appendSVGRectObject()
        if shouldEmitSeparatedLine {
            appendSVGHelperLineObject()
        }
        
        func appendSVGObject() {
            if shouldEmitSeparatedLine {
                let sideMargin: Double = margin * 2
                let width: Double = {
                    let objectWidth: Double = Double(columnViewsList.count) * viewObjectSize.width
                    let objectBetweenMargin: Double = {
                        var objectBetweenMarginTotal: Double = 0
                                                
                        columnViewsList.forEach { columnView in
                            if columnView.columnNumber == 0 {
                                objectBetweenMarginTotal += viewHorizontalMargin
                                // 外側(左)
                                objectBetweenMarginTotal += Double(separatedViews.count) * viewHorizontalMargin/2
                            } else {
                                let count: Int = columnView.viewList
                                    .filter { columnViewView in
                                        separatedViews.contains {
                                            $0.view.nameData.key == columnViewView.view.nameData.key
                                        }
                                    }
                                    .count
                                
                                if columnView.columnNumber < columnViewsList.count - 1 {
                                    objectBetweenMarginTotal += Double(count + 1) * viewHorizontalMargin/2
                                    objectBetweenMarginTotal += viewHorizontalMargin
                                } else {
                                    // 外側(右)
                                    objectBetweenMarginTotal += Double(count) * viewHorizontalMargin/2
                                }
                            }
                        }
                        
                        return objectBetweenMarginTotal
                    }()
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
                    let topPlusMargin: Double = Double(separatedViews.count) * viewVerticalMargin/2
                    return objectHeight + objectBetweenMargin + sideMargin + topPlusMargin
                }()
                
                _svgObjectList.append(
                    .svg(width: width, height: height)
                )
            } else {
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
        
        func appendSVGRectObject() {
            if shouldEmitSeparatedLine {
                columnViewsList.forEach { columnViews in
                    
                    columnViews.viewList.forEach { data in
                        let view: View = data.view
                        let lineNumber: Int = data.lineNumber
                        let fillColorStr: String = view.contentColor.isEmpty == false
                         ? view.contentColor
                         : settings.viewObjectColorStr
                        let strokeColorStr: String = view.borderColor.isEmpty == false
                         ? view.borderColor
                         : settings.viewObjectBorderColorStr
                        
                        if columnViews.columnNumber == 0 {
                            let x: Double = margin + (Double(separatedViews.count) * viewHorizontalMargin/2)
                            let y: Double = margin + (Double(separatedViews.count) * viewVerticalMargin/2)
                            
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
                            
                            view.updateRect(NSRect(x: x, y: y, width: viewObjectSize.width, height: viewObjectSize.height))
                        } else {
                            let includeSeparateViewCountBefore: Int = {
                                if columnViews.columnNumber == 1 {
                                    return 0
                                } else {
                                    let baseColumnViews = columnViewsList.first { $0.columnNumber == columnViews.columnNumber - 1 }
                                    
                                    return baseColumnViews?.viewList
                                        .filter { columnViewView in
                                            separatedViews.contains {
                                                $0.view.nameData.key == columnViewView.view.nameData.key
                                            }
                                        }
                                        .count ?? 0
                                }
                            }()
                            
                            let beforeColumnX: Double = Double(
                                columnViewsList
                                    .first { $0.columnNumber == columnViews.columnNumber - 1 }?
                                    .viewList.first?
                                    .view.rect.minX ?? 0
                            )
                            
                            let x: Double = beforeColumnX + (Double(includeSeparateViewCountBefore + 1) * viewHorizontalMargin/2) + viewHorizontalMargin
                            let y: Double = margin + (Double(lineNumber) * (viewVerticalMargin + viewObjectSize.height)) + Double(separatedViews.count) * viewVerticalMargin/2
                            
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
            } else {
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
        }
        
        func appendSVGHelperLineObject() {
            let sortSeparatedViews: [ColumnViewInfo] = separatedViews.sorted { $0.lineNumber < $1.lineNumber }
            
            sortSeparatedViews.enumerated().forEach { data in
                let _viewInfo = data.element
                let _offset = data.offset
                
                // (1)
                let x2: Double = _viewInfo.view.rect.minX
                let x1: Double = x2 - viewHorizontalMargin/2
                let y1: Double = _viewInfo.view.rect.origin.y + viewVerticalMargin/2
                let y2: Double = y1
                
                _svgObjectList.append(
                    .line(x1: x1,
                          y1: y1,
                          x2: x2,
                          y2: y2,
                          stroke: "CCCCCC",
                          strokeWidth: 1,
                          isMarker: true)
                )
                
                // (2)
                let rootViewOriginY = columnViewsList
                    .first { $0.columnNumber == 0 }?
                    .viewList.first { $0.view.isRoot == false }?
                    .view.rect.origin.y
                
                let x1_2: Double = x1
                let x2_2: Double = x1_2
                let y1_2: Double = Double(rootViewOriginY ?? 0) - ((viewVerticalMargin/2) * Double(_offset))
                let y2_2: Double = y1
                
                _svgObjectList.append(
                    .line(x1: x1_2,
                          y1: y1_2,
                          x2: x2_2,
                          y2: y2_2,
                          stroke: "CCCCCC",
                          strokeWidth: 1,
                          isMarker: false)
                )
                
                // (3)
                let maxColumnNumber: Int = columnViewsList
                    .reduce(into: [Int]()) { partialResult, columnView in
                        if columnView.viewList.contains(where: { $0.view.nameData.key == _viewInfo.view.nameData.key }) {
                            partialResult.append(columnView.columnNumber)
                        }
                    }
                    .max() ?? 0
                let maxColumnNumberColumnViewMaxX: Double = Double(
                    columnViewsList
                        .first { $0.columnNumber == maxColumnNumber }?
                        .viewList.first?
                        .view.rect.maxX ?? 0
                )
                
                let x1_3: Double = x1_2
                let x2_3: Double = maxColumnNumberColumnViewMaxX + ((viewHorizontalMargin/2) * Double(_offset))
                let y1_3: Double = y1_2
                let y2_3: Double = y1_3
                
                _svgObjectList.append(
                    .line(x1: x1_3,
                          y1: y1_3,
                          x2: x2_3,
                          y2: y2_3,
                          stroke: "CCCCCC",
                          strokeWidth: 1,
                          isMarker: false)
                )
                
                // (4)
                let columnViewDic: [Int: ColumnViewInfo] = columnViewsList.reduce(into: [Int: ColumnViewInfo]()) { partialResult, columnViews in
                    let columnViewInfoList = columnViews.viewList.filter { $0.view.nameData.key == _viewInfo.view.nameData.key }
                    columnViewInfoList.forEach { viewInfo in
                        partialResult[columnViews.columnNumber] = viewInfo
                    }
                }
                
                columnViewDic.forEach { data in
                    let _columnViewDicViewInfo: ColumnViewInfo = data.value
                    
                    // (4-1)
                    let x1_4: Double = Double(_columnViewDicViewInfo.view.rect.maxX)
                    let x2_4: Double = x1_4 + (Double(_offset) * (viewHorizontalMargin/2))
                    let y1_4: Double = Double(_columnViewDicViewInfo.view.rect.origin.y) + viewObjectSize.height/2
                    let y2_4: Double = y1_4
                    
                    _svgObjectList.append(
                        .line(x1: x1_4,
                              y1: y1_4,
                              x2: x2_4,
                              y2: y2_4,
                              stroke: "CCCCCC",
                              strokeWidth: 1,
                              isMarker: false)
                    )
                    
                    // (4-2)
                    let x1_4_2: Double = x2_4
                    let x2_4_2: Double = x1_4_2
                    let y1_4_2: Double = y1_3
                    let y2_4_2: Double = y1_4
                    
                    _svgObjectList.append(
                        .line(x1: x1_4_2,
                              y1: y1_4_2,
                              x2: x2_4_2,
                              y2: y2_4_2,
                              stroke: "CCCCCC",
                              strokeWidth: 1,
                              isMarker: false)
                    )
                }
            }
        }
    }
    
    func appendSVGLineObject(shouldEmitSeparatedLine: Bool) {
        if shouldEmitSeparatedLine {
            test()
        } else {
            test2()
        }
    }
    
    func test() {
        columnViewsList.forEach { columnViews in
            let columnNumber: Double = Double(columnViews.columnNumber)
            
            columnViews.viewList.forEach { viewInfo in
                let y: Double = margin + ((viewObjectSize.height + viewVerticalMargin) * Double(viewInfo.lineNumber)) + (viewObjectSize.height / 2) + Double(separatedViews.count) * viewVerticalMargin/2
                
                let x2: Double = Double(viewInfo.view.rect.minX)
                
                let x1: Double = {
                    if viewInfo.transitionData.number == 0 {
                        if columnNumber == 1 {
                            return x2 - viewHorizontalMargin
                        } else {
                            return columnViewsList
                                .first { $0.columnNumber == columnViews.columnNumber - 1 }?
                                .viewList.first?
                                .view.rect.maxX
                        }
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
    
    func test2() {
        columnViewsList.forEach { columnViews in
            let columnNumber: Double = Double(columnViews.columnNumber)
            
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
}
