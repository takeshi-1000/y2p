import Cocoa

public class Settings {
    public var viewObjectSize: NSSize { _viewObjectSize }
    private var _viewObjectSize: NSSize = NSSize(width: 100, height: 50)
    
    public var viewObjectColorStr: String { _viewObjectColorStr }
    private var _viewObjectColorStr: String = "FFFFFF" //white
    
    public var viewObjectBorderColor: NSColor { _viewObjectBorderColor }
    private var _viewObjectBorderColor: NSColor = NSColor.black
    
    public var viewObjectTextColor: NSColor { _viewObjectTextColor }
    private var _viewObjectTextColor: NSColor = NSColor.black
    
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
    
    public var slashWidth: Double { _slashWidth }
    private var _slashWidth: Double = 1
    
    public init() {}
    
    public func updateViewObjectSize(_ viewObjectSize: NSSize) {
        _viewObjectSize = viewObjectSize
    }
    
    public func updateViewObjectColorStr(_ viewObjectColorStr: String) {
        _viewObjectColorStr = viewObjectColorStr
    }
    
    public func updateViewObjectBorderColor(_ viewObjectBorderColor: NSColor) {
        _viewObjectBorderColor = viewObjectBorderColor
    }
    
    public func updateViewObjectTextColor(_ viewObjectTextColor: NSColor) {
        _viewObjectTextColor = viewObjectTextColor
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
    
    public func updateSlashWidth(_ slashWidth: Double) {
        _slashWidth = slashWidth
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

