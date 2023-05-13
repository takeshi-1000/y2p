import Cocoa

public class Settings {
    public var viewObjectSize: NSSize { _viewObjectSize }
    private var _viewObjectSize: NSSize = NSSize(width: 100, height: 50)
    
    public var viewObjectColorStr: String { _viewObjectColorStr }
    private var _viewObjectColorStr: String = "FFFFFF" // white
    
    public var viewObjectBorderColorStr: String { _viewObjectBorderColorStr }
    private var _viewObjectBorderColorStr: String = "000000" // black
    
    public var viewObjectTextColorStr: String { _viewObjectTextColorStr }
    private var _viewObjectTextColorStr: String = "000000" // black
    
    public var viewObjectTextFontSize: Double { _viewObjectTextFontSize }
    private var _viewObjectTextFontSize: Double = 20
    
    public var viewVerticalMargin: Double { _viewVerticalMargin }
    private var _viewVerticalMargin: Double = 20
    
    public var viewHorizontalMargin: Double { _viewHorizontalMargin }
    private var _viewHorizontalMargin: Double = 50
    
    public var enabledRoundCorner: Bool { _enabledRoundCorner }
    private var _enabledRoundCorner: Bool = false
    
    public var margin: Double { _margin }
    private var _margin: Double = 16
    
    public var lineWidth: Double { _lineWidth }
    private var _lineWidth: Double = 1
    
    public var showGuideLines: Bool { _showGuideLines }
    private var _showGuideLines: Bool = true
    
    public init() {}
    
    public func updateViewObjectSize(_ viewObjectSize: NSSize) {
        _viewObjectSize = viewObjectSize
    }
    
    public func updateViewObjectColorStr(_ viewObjectColorStr: String) {
        _viewObjectColorStr = viewObjectColorStr
    }
    
    public func updateViewObjectBorderColorStr(_ viewObjectBorderColorStr: String) {
        _viewObjectBorderColorStr = viewObjectBorderColorStr
    }
    
    public func updateViewObjectTextColorStr(_ viewObjectTextColorStr: String) {
        _viewObjectTextColorStr = viewObjectTextColorStr
    }
    
    public func updateViewObjectTextFontSize(_ viewObjectTextFontSize: Double) {
        _viewObjectTextFontSize = viewObjectTextFontSize
    }
    
    public func updateViewVerticalMargin(_ viewVerticalMargin: Double) {
        _viewVerticalMargin = viewVerticalMargin
    }
    
    public func updateViewHorizontalMargin(_ viewHorizontalMargin: Double) {
        _viewHorizontalMargin = viewHorizontalMargin
    }
    
    public func updateEnabledRoundCorner(_ enabledRoundCorner: Bool) {
        _enabledRoundCorner = enabledRoundCorner
    }
    
    public func updateMargin(_ margin: Double) {
        _margin = margin
    }
    
    public func updateLineWidth(_ lineWidth: Double) {
        _lineWidth = lineWidth
    }
    
    public func updateShowGuideLines(_ showGuideLines: Bool) {
        _showGuideLines = showGuideLines
    }
}
