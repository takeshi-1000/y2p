import Cocoa
import Yaml

struct View {
    var nameData: (key: String, value: String) = (key: "", value: "")
    var index: Int = 0
    var views: [View]
}

var views: [View] = []

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

let fileURL = URL(fileURLWithPath: "/Users/komoritakeshi/me/takeshi-1000/y2p/sample.yml")
do {
    let contents = try String(contentsOf: fileURL, encoding: .utf8)
    let value = try Yaml.load(contents)
    print(value)
    print("==================================")
    
    guard case .dictionary(let dictionaries) = value else {
        throw fatalError()
    }
    
    var startIndex = dictionaries.startIndex
    
    while dictionaries.endIndex > startIndex {
        
        let test = dictionaries[startIndex]
        
        if test.key == .string("views"), case .array(let viewsArray) = test.value {
            views = createViews(index: 0, viewsArray: viewsArray)
        }
        
        if test.key == .string("settings") {
            
        }
        
        startIndex = dictionaries.index(after: startIndex)
    }
    
    print("views :: \(views)")
    
} catch {
    print("Could not read file: \(error)")
}

// 画像のサイズ
let imageSize = NSSize(width: 1000, height: 1000)

// 画像の背景色
let backgroundColor = NSColor.white

// FirstViewの位置とサイズ
let firstViewRect = NSRect(x: 50, y: 150, width: 100, height: 100)

// FirstViewの背景色
let firstViewColor = NSColor.red

// lineViewの位置とサイズ
let lineViewRect = NSRect(x: 150, y: 200, width: 100, height: 1)

// lineの背景色
let lineViewColor = NSColor.black

// SecondViewの位置とサイズ
let secondViewRect = NSRect(x: 250, y: 150, width: 100, height: 100)

// SecondViewの背景色
let secondViewColor = NSColor.blue

// ThirdViewの位置とサイズ
let thirdViewRect = NSRect(x: 250, y: 0, width: 100, height: 100)

// ThirdViewの背景色
let thirdViewColor = NSColor.green

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

NSGraphicsContext.saveGraphicsState()

NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap!)

// 背景色の描画
backgroundColor.setFill()
__NSRectFill(NSRect(origin: .zero, size: imageSize))

// FirstViewの描画
firstViewColor.setFill()
__NSRectFill(firstViewRect)
let firstViewText = "AですAですAですAですAですAですAです"
let firstViewTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: NSColor.white, .font: NSFont.systemFont(ofSize: 24)]
let firstViewTextSize = firstViewText.size(withAttributes: firstViewTextAttributes)
let firstViewTextRect = NSRect(x: firstViewRect.origin.x + (firstViewRect.width - firstViewTextSize.width) / 2, y: firstViewRect.origin.y + (firstViewRect.height - firstViewTextSize.height) / 2, width: firstViewTextSize.width, height: firstViewTextSize.height)
firstViewText.draw(in: firstViewTextRect, withAttributes: firstViewTextAttributes)

// lineViewの描画
lineViewColor.setFill()
__NSRectFill(lineViewRect)

// SecondViewの描画
secondViewColor.setFill()
__NSRectFill(secondViewRect)

// ThirdViewの描画
thirdViewColor.setFill()
__NSRectFill(thirdViewRect)


let path = NSBezierPath()
let angle = CGFloat.pi / 6.0 // 30度をラジアンに変換
let length = CGFloat(100.0)
let startPoint = NSPoint(x: 150, y: 200)
let endPoint = NSPoint(x: 250, y: 0)
path.move(to: startPoint)
path.line(to: endPoint)
path.lineWidth = 1
NSColor.green.setStroke()
path.stroke()

NSGraphicsContext.restoreGraphicsState()

// 画像の保存
let imageData = bitmap?.representation(using: .png, properties: [:])
try? imageData?.write(to: URL(fileURLWithPath: "transition.png"))
