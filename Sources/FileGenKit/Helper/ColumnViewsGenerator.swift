import Data

class ColumnViewsGenerator {
    var columnViewsList: [ColumnViews] { _columnViewsList }
    private var _columnViewsList: [ColumnViews] = []
    
    func generate(views: [View]) {
        generateColumnViewsListForRootView(views: views)
        generateColumnViewsListForSeparatedView(views: views)
    }
    
    func generateColumnViewsListForRootView(views: [View]) {
        guard let rootView = views.first(where: { $0.isRoot }) else {
            return
        }
        generateColumnViews(baseView: rootView,
                            baseViewColumnNumber: 0,
                            baseViewlineNumber: 0)
    }
    
    func generateColumnViewsListForSeparatedView(views: [View]) {
        let separatedViews = views.filter { $0.isRoot == false }
        
        separatedViews.forEach { separatedView in
            if let columnViewsMaxLineNumber = getMaxLineNumber(columnViewsList: _columnViewsList) {
                let lineNumber = columnViewsMaxLineNumber + 1
                generateColumnViews(baseView: separatedView,
                                    baseViewColumnNumber: 0,
                                    baseViewlineNumber: lineNumber)
            }
        }
    }
    
    func generateColumnViews(baseView: View, baseViewColumnNumber: Int, baseViewlineNumber: Int) {
        appendViewToColumnViews(columnNumber: baseViewColumnNumber,
                                lineNumber: baseViewlineNumber,
                                view: baseView)
        
        let nextColumnNumber = baseViewColumnNumber + 1
        
        baseView.views.enumerated().forEach { data in
            let _view = data.element
            let _offset = data.offset
            
            if _offset == 0 {
                generateColumnViews(baseView: _view,
                                    baseViewColumnNumber: nextColumnNumber,
                                    baseViewlineNumber: baseViewlineNumber)
            } else {
                let filteredColumnViewsList: [ColumnViews] = _columnViewsList.filter { $0.columnNumber >= nextColumnNumber }
                if let _columnViewsMaxLineNumber = getMaxLineNumber(columnViewsList: filteredColumnViewsList) {
                    generateColumnViews(baseView: _view,
                                        baseViewColumnNumber: nextColumnNumber,
                                        baseViewlineNumber: _columnViewsMaxLineNumber + 1)
                }
            }
        }
    }
    
    func appendViewToColumnViews(columnNumber: Int, lineNumber: Int, view: View) {
        if let columnViews = _columnViewsList.first(where: { $0.columnNumber == columnNumber }) {
            columnViews.updateViewList(
                lineNumber: lineNumber,
                view: view
            )
        } else {
            _columnViewsList.append(
                ColumnViews(columnNumber: columnNumber,
                            viewList: [lineNumber : view])
            )
        }
    }
    
    func getMaxLineNumber(columnViewsList: [ColumnViews]) -> Int? {
        return columnViewsList
            .reduce(into: [Int]()) { partialResult, columnViews in
                let maxLineNumber = columnViews.viewList.sorted(by: { $0.key > $1.key }).first?.key
                if let _maxLineNumber = maxLineNumber {
                    partialResult.append(_maxLineNumber)
                }
            }
            .max()
    }
}
