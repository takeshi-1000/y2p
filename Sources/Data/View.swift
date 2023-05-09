import Cocoa

public class View {
    public let nameData: (key: String, value: String)
    public let urlStr: String
    public let contentColor: String
    public let borderColor: String
    public let index: Int
    public let isRoot: Bool
    public let views: [View]
    
    public var rect: NSRect { _rect }
    private var _rect: NSRect = .zero
    
    public init(nameData: (key: String, value: String),
                urlStr: String,
                contentColor: String,
                borderColor: String,
                index: Int,
                isRoot: Bool,
                views: [View]) {
        self.nameData = nameData
        self.urlStr = urlStr
        self.contentColor = contentColor
        self.borderColor = borderColor
        self.index = index
        self.isRoot = isRoot
        self.views = views
    }
    
    public func updateRect(_ rect: NSRect) {
        _rect = rect
    }
}
