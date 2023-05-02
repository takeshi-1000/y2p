import Data

struct ColumnViewInfo {
    var lineNumber: Int
    var transitionData: (sourceViewKey: String, number: Int)
    var view: View
}

class ColumnViews {
    public let columnNumber: Int
    public var viewList: [ColumnViewInfo] { _viewList }
    
    private var _viewList: [ColumnViewInfo] = []
    
    public init(columnNumber: Int) {
        self.columnNumber = columnNumber
    }
    
    public func updateViewList(viewInfo: ColumnViewInfo) {
        _viewList.append(viewInfo)
    }
}
