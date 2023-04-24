import Data
import Utility
import Cocoa
import Yaml

public class CLICommander {
    public static func command() throws {
        var views: [View] = []
        var settings: Settings = .init()

        let fileURL = URL(fileURLWithPath: "y2p.yml")
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let value = try Yaml.load(contents)
            
            let dictionaries: ([Yaml : Yaml]) = {
                if case .dictionary(let dictionaries) = value {
                    return dictionaries
                }
                return ([:])
            }()
            
            var startIndex = dictionaries.startIndex
            
            while dictionaries.endIndex > startIndex {
                
                let dictionary = dictionaries[startIndex]
                
                if dictionary.key == .string("views"), case .array(let viewsArray) = dictionary.value {
                    views = ViewsGenerator.generate(index: 0, viewsArray: viewsArray)
                }
                
                if dictionary.key == .string("settings"), case .dictionary(let settingsDictionary) = dictionary.value {
                    settings = SettingsGenerator.generate(settingsInfoList: settingsDictionary)
                }
                
                startIndex = dictionaries.index(after: startIndex)
            }
            
        } catch {
            print("Could not read file: \(error)")
            // TODO: 終了コード
        }

        let viewObjectSize = settings.viewObjectSize
        let viewObjectVerticalMargin: Double = settings.viewVerticalMargin
        let viewObjectHorizontalMargin: Double = settings.viewHorizontalMargin
        let contentMargin: Double = settings.margin

        let imageWidthCalculator = ImageWidthCalculator(viewObjectSizeWidth: viewObjectSize.width,
                                                         viewObjectHorizontalMargin: viewObjectHorizontalMargin)
        let imageHeightCalculator = ImageHeightCalculator(viewObjectSizeHeight: viewObjectSize.height,
                                                          viewObjectVerticalMargin: viewObjectVerticalMargin)
        let contentWidth = imageWidthCalculator.calculate(index: 0, views: views)
        let contentHeight = imageHeightCalculator.calculate(views: views)
        let imageWidth = contentWidth + (contentMargin * 2)
        let imageHeight = contentHeight + (contentMargin * 2)
        let imageSize = NSSize(width: imageWidth,
                               height: imageHeight)

        // 画像の背景色
        let backgroundColor = NSColor.white

        // 画像の作成
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil,
                                      pixelsWide: Int(imageSize.width),
                                      pixelsHigh: Int(imageSize.height),
                                      bitsPerSample: 8,
                                      samplesPerPixel: 4,
                                      hasAlpha: true,
                                      isPlanar: false,
                                      colorSpaceName: NSColorSpaceName.calibratedRGB,
                                      bytesPerRow: 0,
                                      bitsPerPixel: 0)
        bitmap?.canBeCompressed(using: .lzw)

        NSGraphicsContext.saveGraphicsState()

        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap!)

        // 背景色の描画
        backgroundColor.setFill()
        __NSRectFill(NSRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))

        views.enumerated().forEach { data in
            // 第一階層
            let view: View = data.element
            let index: Int = data.offset
            
            let preViewMaxCount: Int = {
                if index != 0 {
                    let views = views[0...(index - 1)].map { $0 }
                    // TODO: ここが浮いているのでもう少し改善したい
                    return ImageHeightCalculator.calculateMaxVerticalCount(views: views)
                } else {
                    return 0
                }
            }()
            
            let viewY = contentMargin + (Double(preViewMaxCount) * (viewObjectVerticalMargin + viewObjectSize.height))
                
            setFillView(x: contentMargin,
                        y: viewY,
                        view: view)
            
            // 第二階層以降
            setFillForViewViews(view.views, baseViewY: viewY)
            // 斜線
            setSlashForViewViews(baseView: view)
            
            func setFillForViewViews(_ views: [View], baseViewY: Double) {
                var nextViews: [View] = []
                views.enumerated().forEach { data in
                    let _view: View = data.element
                    let _viewOffSet: Int = data.offset
                    
                    let x: Double = (Double(_view.index) * (viewObjectHorizontalMargin + viewObjectSize.width)) + contentMargin
                    let y: Double = Double(_viewOffSet) * (viewObjectVerticalMargin + viewObjectSize.height) + baseViewY
                    
                    setFillView(x: x, y: y, view: _view)
                    
                    if _view.views.count > 0 {
                        nextViews.append(contentsOf: _view.views)
                    }
                }
                
                if nextViews.isEmpty == false {
                    setFillForViewViews(nextViews, baseViewY: baseViewY)
                }
            }
            
            func setFillView(x: Double, y: Double, view: View) {
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
            func setSlashForViewViews(baseView: View) {
                baseView.views.enumerated().forEach { data in
                    let _view: View = data.element
                    let startPoint = NSPoint(x: baseView.rect.maxX, y: baseView.rect.minY + (settings.viewObjectSize.height / 2))
                    let endPoint = NSPoint(x: _view.rect.minX, y: _view.rect.minY + (settings.viewObjectSize.height / 2))
                    
                    let slashColor: NSColor = {
                        
                        let filteredtransitionTypeKey = _view.transitionTypeKey.isEmpty == false
                                                             ? _view.transitionTypeKey
                                                             : settings.defaultTransitionTypeKey
                        
                        if let defaultContext = settings.transitionTypeList
                            .first(where: { $0.typeStr == filteredtransitionTypeKey }) {
                            return NSColor(hex: defaultContext.colorStr)
                        } else {
                            return NSColor(hex: "000000")
                        }
                    }()
                    
                    setSlash(startPoint: startPoint, endPoint: endPoint, color: slashColor)
                    
                    if _view.views.count > 0 {
                        setSlashForViewViews(baseView: _view)
                    }
                }
            }
            
            func setSlash(startPoint: NSPoint, endPoint: NSPoint, color: NSColor) {
                let path = NSBezierPath()
                path.move(to: startPoint)
                path.line(to: endPoint)
                path.lineWidth = settings.slashWidth
                color.setStroke()
                path.stroke()
            }
        }

        NSGraphicsContext.restoreGraphicsState()

        // 画像の保存
        let imageData = bitmap?.representation(using: .png, properties: [:])
        try? imageData?.write(to: URL(fileURLWithPath: settings.imageName))
    }
}
