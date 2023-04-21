import Cocoa

public class View {
    public var nameData: (key: String, value: String) = (key: "", value: "")
    public var transitionTypeKey: String
    public var contentColor: String = ""
    public var borderColor: String = ""
    public var index: Int = 0
    public var views: [View]
    public var cgrect: NSRect = .zero
    
    public init(nameData: (key: String, value: String),
         transitionTypeKey: String,
         contentColor: String,
         borderColor: String,
         index: Int,
         views: [View]) {
        self.nameData = nameData
        self.transitionTypeKey = transitionTypeKey
        self.contentColor = contentColor
        self.borderColor = borderColor
        self.index = index
        self.views = views
    }
}
