import Cocoa

public class View {
    public let nameData: (key: String, value: String)
    public let urlStr: String
    public let transitionTypeKey: String
    public let contentColor: String
    public let borderColor: String
    public let index: Int
    public let views: [View]
    
    public var rect: NSRect { _rect }
    private var _rect: NSRect = .zero
    
    public init(nameData: (key: String, value: String),
                urlStr: String,
                transitionTypeKey: String,
                contentColor: String,
                borderColor: String,
                index: Int,
                views: [View]) {
        self.nameData = nameData
        self.urlStr = urlStr
        self.transitionTypeKey = transitionTypeKey
        self.contentColor = contentColor
        self.borderColor = borderColor
        self.index = index
        self.views = views
    }
    
    public func updateRect(_ rect: NSRect) {
        _rect = rect
    }
}
