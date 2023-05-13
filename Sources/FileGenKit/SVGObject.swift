import Cocoa

indirect enum SVGObjectType {
    case svg(width: Double, height: Double)
    case rect(rect: NSRect, fill: String, stroke: String, enabledRound: Bool)
    case text(x: Double, y: Double, fontSize: Double, fill: String, value: String)
    case line(x1: Double, y1: Double, x2: Double, y2: Double, stroke: String, strokeWidth: Double, isMarker: Bool)
    case dotLine(line: SVGObjectType)
    case url(urlStr: String, rect: SVGObjectType, text: [SVGObjectType])
}
