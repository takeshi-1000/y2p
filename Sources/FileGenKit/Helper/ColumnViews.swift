import Data

class ColumnViews {
    public let columnNumber: Int
    public var viewList: [Int : View] { _viewList }
    
    private var _viewList: [Int : View] = [:]
    
    public init(columnNumber: Int, viewList: [Int : View] = [:]) {
        self.columnNumber = columnNumber
        self._viewList = viewList
    }
    
    public func updateViewList(lineNumber: Int, view: View) {
        _viewList[lineNumber] = view
    }
}
