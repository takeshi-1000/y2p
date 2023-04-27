import Data
import Utility
import Cocoa

public class ImageGenerator: FileGeneratable {
    typealias Content = Data
    let views: [View]
    let settings: Settings
    
    required public init(views: [View], settings: Settings) {
        self.views = views
        self.settings = settings
    }
    
    public func generate() throws -> Data? {
        let imageWidthCalculator = FileWidthCalculator(margin: margin,
                                                       viewObjectSizeWidth: viewObjectSize.width,
                                                       viewObjectHorizontalMargin: viewObjectHorizontalMargin)
        let imageHeightCalculator = FileHeightCalculator(margin: margin,
                                                         viewObjectSizeHeight: viewObjectSize.height,
                                                         viewObjectVerticalMargin: viewObjectVerticalMargin)
        let contentWidth = imageWidthCalculator.calculate(index: 0, views: views)
        let contentHeight = imageHeightCalculator.calculate(views: views)
        
        let imageSize = NSSize(width: contentWidth, height: contentHeight)

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

        let viewsPainter = ViewsPainter(views: views,
                                        settings: settings,
                                        imageHeight: contentHeight)
        viewsPainter.paint()

        NSGraphicsContext.restoreGraphicsState()

        // 画像の保存
        return bitmap?.representation(using: .png, properties: [:])
    }
    
}
