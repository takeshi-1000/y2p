import Cocoa

public struct LineView {
    public let startPoint: NSPoint
    public let endPoint: NSPoint
    public let colorStr: String
    
    public init(startPoint: NSPoint, endPoint: NSPoint, colorStr: String) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.colorStr = colorStr
    }
}
