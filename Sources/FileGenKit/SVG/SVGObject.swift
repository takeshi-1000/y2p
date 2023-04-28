import Cocoa

enum SVGObjectType {
    case svg(width: Double, height: Double)
    case rect(x: Double, y: Double, width: Double, height: Double, fill: String, stroke: String)
    case text(x: Double, y: Double, fontSize: Double, fill: String)
    case line(x1: Double, y1: Double, x2: Double, y2: Double, stroke: String, strokeWidth: Double)
}
