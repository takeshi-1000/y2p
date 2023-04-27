import Data
import Cocoa

protocol FileGeneratable {
    associatedtype Content
    var views: [View] { get }
    var settings: Settings { get }
    
    init(views: [View], settings: Settings)
    func generate() throws -> Content?
}

extension FileGeneratable {
    var viewObjectSize: NSSize {
        settings.viewObjectSize
    }
    
    var viewObjectVerticalMargin: Double {
        settings.viewVerticalMargin
    }
    
    var viewObjectHorizontalMargin: Double {
        settings.viewHorizontalMargin
    }
    
    var margin: Double {
        settings.margin
    }
    
    func calculateWidth() -> Double {
        let imageWidthCalculator = FileWidthCalculator(margin: margin,
                                                       viewObjectSizeWidth: viewObjectSize.width,
                                                       viewObjectHorizontalMargin: viewObjectHorizontalMargin)
        return imageWidthCalculator.calculate(index: 0, views: views)
    }
    
    func calculateHeight() -> Double {
        let imageHeightCalculator = FileHeightCalculator(margin: margin,
                                                         viewObjectSizeHeight: viewObjectSize.height,
                                                         viewObjectVerticalMargin: viewObjectVerticalMargin)
        return imageHeightCalculator.calculate(views: views)
    }
}
