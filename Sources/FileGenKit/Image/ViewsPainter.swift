import Data
import Cocoa

class ViewsPainter {
    private let views: [View]
    private let settings: Settings
    private let imageHeight: Double
    
    init(views: [View], settings: Settings, imageHeight: Double) {
        self.views = views
        self.settings = settings
        self.imageHeight = imageHeight
    }
    
    func paint() {
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
            paintView(x: margin, y: viewY, view: view)
            
            // 第二階層以降
            paintViews(view.views, baseViewY: viewY)
            // 斜線
            paintViewSlashs(baseView: view)
            
            func paintViews(_ views: [View], baseViewY: Double) {
                var nextViews: [View] = []
                views.enumerated().forEach { data in
                    let _view: View = data.element
                    let _viewOffSet: Int = data.offset
                    
                    let x: Double = (Double(_view.index) * (viewHorizontalMargin + viewObjectSize.width)) + margin
                    let y: Double = Double(_viewOffSet) * (viewVerticalMargin + viewObjectSize.height) + baseViewY
                    
                    paintView(x: x, y: y, view: _view)
                    
                    if _view.views.count > 0 {
                        nextViews.append(contentsOf: _view.views)
                    }
                }
                
                if nextViews.isEmpty == false {
                    paintViews(nextViews, baseViewY: baseViewY)
                }
            }
            
            func paintView(x: Double, y: Double, view: View) {
                let viewRect: NSRect = .init(x: x,
                                             y: imageHeight - y - viewObjectSize.height,
                                             width: viewObjectSize.width,
                                             height: viewObjectSize.height)
                if view.contentColor.isEmpty {
                    settings.viewObjectColor.setFill()
                } else {
                    NSColor(hex: view.contentColor).setFill()
                }
                __NSRectFill(viewRect)
                let viewTextAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: settings.viewObjectTextColor,
                    .font: NSFont.systemFont(ofSize: settings.viewObjectTextFontSize)
                ]
                view.nameData.value.draw(in: viewRect, withAttributes: viewTextAttributes)
                
                // TODO: あとで試す
                /*
                let hoge = NSAttributedString(string: view.nameData.value, attributes: viewTextAttributes)
                
                let hoge2 = hoge.boundingRect(with: NSSize(width: settings.viewObjectSize.width,
                                                           height: CGFloat.greatestFiniteMagnitude),
                                              options: [.usesLineFragmentOrigin, .usesFontLeading])
                
                print("@@@ \(view.nameData.value) :: \(hoge2)")
                 */
                
                // 枠線
                let borderPath = NSBezierPath(rect: viewRect)
                borderPath.lineWidth = 1.0
                if view.borderColor.isEmpty {
                    settings.viewObjectBorderColor.setStroke()
                } else {
                    NSColor(hex: view.borderColor).setStroke()
                }
                borderPath.stroke()
                // view情報にNSRectセット
                view.updateRect(viewRect)
            }
            
            func paintViewSlashs(baseView: View) {
                baseView.views.enumerated().forEach { data in
                    let _view: View = data.element
                    let startPoint = NSPoint(x: baseView.rect.maxX, y: baseView.rect.minY + (settings.viewObjectSize.height / 2))
                    let endPoint = NSPoint(x: _view.rect.minX, y: _view.rect.minY + (settings.viewObjectSize.height / 2))
                    
                    let slashColor: NSColor = {
                        let defaultTransitionTypeKey = settings.transitionTypeList
                            .first { $0.isDefault }?.typeStr ?? settings.transitionTypeList.first?.typeStr
                        let filteredtransitionTypeKey = _view.transitionTypeKey.isEmpty == false
                                                             ? _view.transitionTypeKey
                                                             : defaultTransitionTypeKey
                        
                        if let defaultContext = settings.transitionTypeList
                            .first(where: { $0.typeStr == filteredtransitionTypeKey }) {
                            return NSColor(hex: defaultContext.colorStr)
                        } else {
                            return NSColor(hex: "000000")
                        }
                    }()
                    
                    paintSlash(startPoint: startPoint, endPoint: endPoint, color: slashColor)
                    
                    if _view.views.count > 0 {
                        paintViewSlashs(baseView: _view)
                    }
                }
            }
            
            func paintSlash(startPoint: NSPoint, endPoint: NSPoint, color: NSColor) {
                let path = NSBezierPath()
                path.move(to: startPoint)
                path.line(to: endPoint)
                path.lineWidth = settings.slashWidth
                color.setStroke()
                path.stroke()
            }
        }
    }
}
