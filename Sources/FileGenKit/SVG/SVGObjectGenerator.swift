import Data
import Cocoa

class SVGObjectGenerator {
    private let views: [View]
    private let settings: Settings
    
    var svgObjectList: [SVGObjectType] {  _svgObjectList }
    private var _svgObjectList: [SVGObjectType] = []
    
    init(views: [View], settings: Settings) {
        self.views = views
        self.settings = settings
    }
    
    func generate() {
        let margin: Double = settings.margin
        let viewVerticalMargin: Double = settings.viewVerticalMargin
        let viewHorizontalMargin: Double = settings.viewHorizontalMargin
        let viewObjectSize: NSSize = settings.viewObjectSize
        
        views.enumerated().forEach { data in
            // 第一階層
            let view: View = data.element
            let index: Int = data.offset
            
            let preViewMaxCount: Int = {
                if index != 0 {
                    let views = views[0...(index - 1)].map { $0 }
                    // TODO: ここが浮いているのでもう少し改善したい。設置したViewListのうち最も高いものを算出すればできそうな気がする
                    return FileHeightCalculator.calculateMaxVerticalCount(views: views)
                } else {
                    return 0
                }
            }()
            
            let viewY = margin + (Double(preViewMaxCount) * (viewVerticalMargin + viewObjectSize.height))
            generateRect(x: margin, y: viewY, view: view)
            
            // 第二階層以降
            generateRectsFromViews(view.views, baseViewY: viewY)
            
            // 斜線
            generateLinesFromViews(baseView: view)
            
            func generateRectsFromViews(_ views: [View], baseViewY: Double) {
                var nextViews: [View] = []
                views.enumerated().forEach { data in
                    let _view: View = data.element
                    let _viewOffSet: Int = data.offset
                    
                    let x: Double = (Double(_view.index) * (viewHorizontalMargin + viewObjectSize.width)) + margin
                    let y: Double = Double(_viewOffSet) * (viewVerticalMargin + viewObjectSize.height) + baseViewY
                    
                    generateRect(x: x, y: y, view: _view)
                    
                    if _view.views.count > 0 {
                        nextViews.append(contentsOf: _view.views)
                    }
                }
                
                if nextViews.isEmpty == false {
                    generateRectsFromViews(nextViews, baseViewY: baseViewY)
                }
            }
            
            func generateRect(x: Double, y: Double, view: View) {
                // view.rectを使用してlineのrectが算出されることに注意
                view.updateRect(.init(x: x,
                                      y: y,
                                      width: viewObjectSize.width,
                                      height: viewObjectSize.height))
                
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
            
            func generateLinesFromViews(baseView: View) {
                baseView.views.enumerated().forEach { data in
                    let _view: View = data.element
                    let startPoint = NSPoint(x: baseView.rect.maxX, y: baseView.rect.minY + (settings.viewObjectSize.height / 2))
                    let endPoint = NSPoint(x: _view.rect.minX, y: _view.rect.minY + (settings.viewObjectSize.height / 2))
                    
                    let lineColor: String = {
                        let defaultTransitionTypeKey = settings.transitionTypeList
                            .first { $0.isDefault }?.typeStr ?? settings.transitionTypeList.first?.typeStr
                        let filteredtransitionTypeKey = _view.transitionTypeKey.isEmpty == false
                                                             ? _view.transitionTypeKey
                                                             : defaultTransitionTypeKey
                        
                        if let defaultContext = settings.transitionTypeList
                            .first(where: { $0.typeStr == filteredtransitionTypeKey }) {
                            return defaultContext.colorStr
                        } else {
                            return "000000"
                        }
                    }()
                    
                    _svgObjectList.append(
                        .line(x1: startPoint.x,
                              y1: startPoint.y,
                              x2: endPoint.x,
                              y2: endPoint.y,
                              stroke: lineColor,
                              strokeWidth: settings.lineWidth,
                              isMarker: false)
                    )
                                
                    if _view.views.count > 0 {
                        generateLinesFromViews(baseView: _view)
                    }
                }
            }
        }
        
    }
}
