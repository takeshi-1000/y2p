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
    
    public var margin: Double { _margin }
    private var _margin: Double = 16
    
    public var transitionTypeList: [TransitionType] { _transitionTypeList }
    private var _transitionTypeList: [TransitionType] = []
    
    public var lineWidth: Double { _lineWidth }
    private var _lineWidth: Double = 1
    
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
    
    public func updateMargin(_ margin: Double) {
        _margin = margin
    }
    
    public func updateTransitionTypeList(_ transitionTypeList: [TransitionType]) {
        _transitionTypeList = transitionTypeList
    }
    
    public func updateLineWidth(_ lineWidth: Double) {
        _lineWidth = lineWidth
    }
}

public struct TransitionType {
    public let typeStr: String
    public let colorStr: String
    public let isDefault: Bool
    
    public init(typeStr: String, colorStr: String, isDefault: Bool) {
        self.typeStr = typeStr
        self.colorStr = colorStr
        self.isDefault = isDefault
    }
}

