import Cocoa
import Yaml

struct View {
    var nameData: (key: String, value: String) = (key: "", value: "")
    var index: Int = 0
    var views: [View]
}

struct Settings {
    var viewObjectSize: NSSize = NSSize(width: 100, height: 50)
    var viewObjectColor: NSColor = NSColor.red
    var viewObjectTextColor: NSColor = NSColor.white
    var viewObjectTextFontSize: Double = 20
    var viewVerticalMargin: Double = 16
    var viewHorizontalMargin: Double = 50
    var margin: Double = 16
    var imageName: String = "transition.png"
}

var views: [View] = []
var settings: Settings = .init()

func createMaxVerticalCount(viewsArray: [View]) -> Int {
    var count: Int = 0
    
    viewsArray.forEach { viewArrayItem in
        var viewsTotalCountList: [Int] = []
        
        if viewArrayItem.views.count > 0 {
            viewsTotalCountList.append(viewArrayItem.views.count)
            
            func testViews(views: [View]) {
                if views.count > 0 {
                    viewsTotalCountList.append(views.count)
                    
                    views.forEach { view in
                        testViews(views: view.views)
                    }
                } else {
                    viewsTotalCountList.append(1)
                }
            }
        } else {
            viewsTotalCountList.append(1)
        }

        count += viewsTotalCountList.max() ?? 1
    }
    
    return count
}

func createMaxHorizontalCount(index: Int, viewsArray: [View]) -> Int {
    var indexList: [Int] = [index]
    
    viewsArray.forEach { view in
        if view.views.count > 0 {
            indexList.append(createMaxHorizontalCount(index: index + 1, viewsArray: view.views))
        }
    }
    
    return indexList.max() ?? index
}

func createViews(index: Int, viewsArray: [Yaml]) -> [View] {
    var _views: [View] = []
    
    viewsArray.forEach { viewData in
        var _nameKey: String = ""
        var _nameValue: String = ""
        var _childviews: [View] = []
        
        if case .dictionary(let viewsDataDictionaries) = viewData {
            viewsDataDictionaries.forEach { viewsDataDictionary in
                if case .string(let viewNameKey) = viewsDataDictionary.key,
                   case .dictionary(let viewInfoList) = viewsDataDictionary.value {
                    _nameKey = viewNameKey
                    
                    viewInfoList.forEach { viewInfo in
                        if case .string("name") = viewInfo.key,
                           case .string(let viewNameValue) = viewInfo.value {
                            _nameValue = viewNameValue
                        }
                        
                        if case .string("views") = viewInfo.key,
                           case .array(let childViews) = viewInfo.value {
                            _childviews = createViews(index: index + 1, viewsArray: childViews)
                        }
                    }
                }
            }
        }
        
        _views.append(
            View(nameData: (key: _nameKey, value: _nameValue),
                 index: index,
                 views: _childviews)
        )
    }
    
    return _views
}

func createSettings(originalSettings: Settings, settingsInfoList: [Yaml : Yaml]) -> Settings {
    var _settings = originalSettings
        
    settingsInfoList.forEach { settings in
        
        if case .string("margin") = settings.key,
           case .int(let margin) = settings.value {
            _settings.margin = Double(margin)
        }
        
        if case .string("imageName") = settings.key,
           case .string(let imageName) = settings.value {
            _settings.imageName = imageName
        }
        
        if case .string("object") = settings.key,
           case .dictionary(let objectInfoDictionaryArray) = settings.value {
            
            objectInfoDictionaryArray.forEach { objectInfoDic in
                if case .string("verticalMargin") = objectInfoDic.key,
                   case .int(let verticalMargin) = objectInfoDic.value {
                    _settings.viewVerticalMargin = Double(verticalMargin)
                }
                
                if case .string("horizontalMargin") = objectInfoDic.key,
                   case .int(let horizontalMargin) = objectInfoDic.value {
                    _settings.viewHorizontalMargin = Double(horizontalMargin)
                }
                /*
                if case .string("contentColor") = objectInfoDic.key,
                   case .string(let contentColorHexCode) = objectInfoDic.value {
                    _settings.viewObjectColor = NSColor(hex: contentColorHexCode)
                }
                
                if case .string("textColor") = objectInfoDic.key,
                   case .string(let textColorHexCode) = objectInfoDic.value {
                    _settings.viewObjectTextColor = NSColor(hex: textColorHexCode)
                }
                 */
                                
                if case .string("size") = objectInfoDic.key,
                   case .dictionary(let sizeDictionaries) = objectInfoDic.value {
                    
                    sizeDictionaries.forEach { sizeDic in
                        if case .string("width") = sizeDic.key,
                           case .int(let width) = sizeDic.value {
                            _settings.viewObjectSize.width = Double(width)
                        }
                        
                        if case .string("height") = sizeDic.key,
                           case .int(let height) = sizeDic.value {
                            _settings.viewObjectSize.height = Double(height)
                        }
                    }
                }
            }
        }
    }
        
    return _settings
}

let fileURL = URL(fileURLWithPath: "/Users/komoritakeshi/me/takeshi-1000/y2p/sample.yml")
do {
    let contents = try String(contentsOf: fileURL, encoding: .utf8)
    let value = try Yaml.load(contents)
    
    guard case .dictionary(let dictionaries) = value else {
        throw fatalError()
    }
    
    var startIndex = dictionaries.startIndex
    
    while dictionaries.endIndex > startIndex {
        
        let dictionary = dictionaries[startIndex]
        
        if dictionary.key == .string("views"), case .array(let viewsArray) = dictionary.value {
            views = createViews(index: 0, viewsArray: viewsArray)
        }
        
        if dictionary.key == .string("settings"), case .dictionary(let settingsDictionary) = dictionary.value {
            settings = createSettings(originalSettings: settings, settingsInfoList: settingsDictionary)
        }
        
        startIndex = dictionaries.index(after: startIndex)
    }
    
} catch {
    print("Could not read file: \(error)")
}

// 水平方向にどれくらい深くなるか
var maxHorizontalDeepCount = createMaxHorizontalCount(index: 0, viewsArray: views)
// 垂直方向にどれくらい深くなるか
var maxVerticalDeepCount = createMaxVerticalCount(viewsArray: views)

let viewObjectSize = settings.viewObjectSize
let viewObjectVerticalMargin: Double = settings.viewVerticalMargin
let viewObjectHorizontalMargin: Double = settings.viewHorizontalMargin
let contentMargin: Double = settings.margin

let contentWidth = viewObjectSize.width * Double(maxHorizontalDeepCount) + viewObjectHorizontalMargin * Double(maxHorizontalDeepCount - 1)
let contentHeight = viewObjectSize.height * Double(maxVerticalDeepCount) + viewObjectVerticalMargin * Double(maxVerticalDeepCount - 1)
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
    let view: View = data.element
    let index: Int = data.offset
    
    let preViewMaxCount: Int = {
        if index != 0 {
            let views = views[0...(index - 1)].map { $0 }
            return createMaxVerticalCount(viewsArray: views)
        } else {
            return 0
        }
    }()
    
    let viewY = contentMargin + (Double(preViewMaxCount) * (viewObjectVerticalMargin + viewObjectSize.height))
        
    setFillView(x: contentMargin,
                y: viewY,
                viewText: view.nameData.value)
    
    setFillForViewViews(view.views, baseViewY: viewY)
    
    func setFillForViewViews(_ views: [View], baseViewY: Double) {
        views.enumerated().forEach { data in
            let _view: View = data.element
            let _viewOffSet: Int = data.offset
            
            let x: Double = (Double(_view.index) * (viewObjectHorizontalMargin + viewObjectSize.width)) + contentMargin
            let y: Double = Double(_viewOffSet) * (viewObjectVerticalMargin + viewObjectSize.height) + baseViewY
            
            setFillView(x: x, y: y, viewText: _view.nameData.value)
            
            if _view.views.count > 0 {
                setFillForViewViews(_view.views, baseViewY: baseViewY)
            }
        }
    }
    
    func setFillView(x: Double, y: Double, viewText: String) {
        let viewRect: NSRect = .init(x: x,
                                     y: imageHeight - y - viewObjectSize.height,
                                     width: viewObjectSize.width,
                                     height: viewObjectSize.height)
        settings.viewObjectColor.setFill()
        __NSRectFill(viewRect)
        let viewTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: settings.viewObjectTextColor, .font: NSFont.systemFont(ofSize: settings.viewObjectTextFontSize)
        ]
        let viewTextSize = viewText.size(withAttributes: viewTextAttributes)
        let viewTextRect = NSRect(x: viewRect.origin.x + (viewRect.width - viewTextSize.width) / 2,
                                  y: viewRect.origin.y + (viewRect.height - viewTextSize.height) / 2,
                                  width: viewTextSize.width,
                                  height: viewTextSize.height)
        viewText.draw(in: viewRect, withAttributes: viewTextAttributes)
    }
}

NSGraphicsContext.restoreGraphicsState()

// 画像の保存
let imageData = bitmap?.representation(using: .png, properties: [:])
try? imageData?.write(to: URL(fileURLWithPath: settings.imageName))

print("Success created!")

