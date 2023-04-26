import Data

class FileHeightCalculator {
    private let viewObjectSizeHeight: Double
    private let viewObjectVerticalMargin: Double
    
    init(viewObjectSizeHeight: Double, viewObjectVerticalMargin: Double) {
        self.viewObjectSizeHeight = viewObjectSizeHeight
        self.viewObjectVerticalMargin = viewObjectVerticalMargin
    }
    
    func calculate(views: [View]) -> Double {
        let maxCount = FileHeightCalculator.calculateMaxVerticalCount(views: views)
        
        let maxViewObjectSizeHeightTotal: Double = viewObjectSizeHeight * Double(maxCount)
        let viewObjectVerticalMarginTotal: Double = viewObjectVerticalMargin * Double(maxCount - 1)
        
        return maxViewObjectSizeHeightTotal + viewObjectVerticalMarginTotal
    }
    
    /*
     e.g 下記のように、垂直方向にどれだけ深いかを算出するためのロジック
     ========
     0 1 2 3
       1 2 3
       1     → ここまでで3
     0 1 2 3
           3
           3 → ここまでで6
     0       → ここまでで7
     ========
     */
    static func calculateMaxVerticalCount(views: [View]) -> Int {
        var count: Int = 0
        
        views.forEach { view in
            var viewsTotalCountList: [Int] = [1] // ここを通過する時点で1つは存在するので
            
            calcTotalCountEveryViews(view.views)
            
            func calcTotalCountEveryViews(_ views: [View]) {
                var _count = 0
                var _nextViews: [View] = []
                
                views.forEach { _view in
                    _count += _view.views.count
                    _nextViews.append(contentsOf: _view.views)
                }
                
                viewsTotalCountList.append(_count)
                
                if _nextViews.isEmpty == false {
                    calcTotalCountEveryViews(_nextViews)
                }
            }

            count += viewsTotalCountList.max() ?? 1
        }
        
        return count
    }
}
