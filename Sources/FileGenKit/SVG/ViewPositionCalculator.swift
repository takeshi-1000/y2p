import Data
import Cocoa

/// this class has two function, which first is to calculate every view position,
/// and second is to generate line view object list
class ViewPositionCalculator {
    private let views: [View]
    private let settings: Settings
    
    var lineViews: [LineView] {  _lineViews }
    private var _lineViews: [LineView] = []
    
    init(views: [View], settings: Settings) {
        self.views = views
        self.settings = settings
    }
    
    func calculate() {
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
            configureViewPosition(x: margin, y: viewY, view: view)
            
            // 第二階層以降
            configureViewsPosition(view.views, baseViewY: viewY)
            
            // 斜線
            configureLineViewsPosition(baseView: view)
            
            func configureViewsPosition(_ views: [View], baseViewY: Double) {
                var nextViews: [View] = []
                views.enumerated().forEach { data in
                    let _view: View = data.element
                    let _viewOffSet: Int = data.offset
                    
                    let x: Double = (Double(_view.index) * (viewHorizontalMargin + viewObjectSize.width)) + margin
                    let y: Double = Double(_viewOffSet) * (viewVerticalMargin + viewObjectSize.height) + baseViewY
                    
                    configureViewPosition(x: x, y: y, view: _view)
                    
                    if _view.views.count > 0 {
                        nextViews.append(contentsOf: _view.views)
                    }
                }
                
                if nextViews.isEmpty == false {
                    configureViewsPosition(nextViews, baseViewY: baseViewY)
                }
            }
            
            func configureViewPosition(x: Double, y: Double, view: View) {
                let viewRect: NSRect = .init(x: x,
                                             y: y,
                                             width: viewObjectSize.width,
                                             height: viewObjectSize.height)
                view.updateRect(viewRect)
            }
            
            func configureLineViewsPosition(baseView: View) {
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
                    
                    _lineViews.append(
                        LineView(startPoint: startPoint,
                                 endPoint: endPoint,
                                 colorStr: lineColor)
                    )
                                        
                    if _view.views.count > 0 {
                        configureLineViewsPosition(baseView: _view)
                    }
                }
            }
        }
        
    }
}
