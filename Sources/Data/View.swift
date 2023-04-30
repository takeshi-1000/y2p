import Cocoa

public class View {
    public let nameData: (key: String, value: String)
    public let urlStr: String
    public let transitionTypeKey: String
    public let contentColor: String
    public let borderColor: String
    public var index: Int { _index }
    private var _index: Int = 0
    public let isRoot: Bool
//    public let views: [View]
    
    public var views: [View] { _views }
    private var _views: [View] = []
    
    public var rect: NSRect { _rect }
    private var _rect: NSRect = .zero
    
    public init(nameData: (key: String, value: String),
                urlStr: String,
                transitionTypeKey: String,
                contentColor: String,
                borderColor: String,
                index: Int,
                isRoot: Bool,
                views: [View]) {
        self.nameData = nameData
        self.urlStr = urlStr
        self.transitionTypeKey = transitionTypeKey
        self.contentColor = contentColor
        self.borderColor = borderColor
        self._index = index
        self.isRoot = isRoot
        self._views = views
    }
    
    public func updateRect(_ rect: NSRect) {
        _rect = rect
    }
    
    public func updateViews(_ views: [View]) {
        _views = views
    }
    
    public func updateIndex(_ index: Int) {
        _index = index
    }
}
