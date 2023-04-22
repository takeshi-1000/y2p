import Cocoa

public struct Settings {
    public var viewObjectSize: NSSize = NSSize(width: 100, height: 50)
    public var viewObjectColor: NSColor = NSColor.white
    public var viewObjectBorderColor: NSColor = NSColor.black
    public var viewObjectTextColor: NSColor = NSColor.black
    public var viewObjectTextFontSize: Double = 20
    public var viewVerticalMargin: Double = 16
    public var viewHorizontalMargin: Double = 50
    public var margin: Double = 16
    public var imageName: String = "transition.png"
    public var defaulttransitionTypeKey: String = ""
    public var transitionTypeList: [TransitionType] = []
    public var slashWidth: Double = 1
    
    public struct TransitionType {
        public var typeStr: String = ""
        public var colorStr: String = ""
        
        public init(typeStr: String, colorStr: String) {
            self.typeStr = typeStr
            self.colorStr = colorStr
        }
    }
    
    public init() {}
}

