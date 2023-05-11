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
}
