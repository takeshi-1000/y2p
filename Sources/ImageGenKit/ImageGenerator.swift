import Data
import Utility
import Cocoa

public class ImageGenerator {
    private let views: [View]
    private let settings: Settings
    
    public init(views: [View], settings: Settings) {
        self.views = views
        self.settings = settings
    }
    
    public func generate() throws -> Data? {
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

        let viewsPainter = ViewsPainter(views: views, settings: settings, imageHeight: imageHeight)
        viewsPainter.paint()

        NSGraphicsContext.restoreGraphicsState()

        // 画像の保存
        return bitmap?.representation(using: .png, properties: [:])
    }
    
}
