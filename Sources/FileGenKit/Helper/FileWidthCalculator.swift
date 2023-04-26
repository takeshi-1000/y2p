import Data

class FileWidthCalculator {
    private let viewObjectSizeWidth: Double
    private let viewObjectHorizontalMargin: Double
    
    init(viewObjectSizeWidth: Double, viewObjectHorizontalMargin: Double) {
        self.viewObjectSizeWidth = viewObjectSizeWidth
        self.viewObjectHorizontalMargin = viewObjectHorizontalMargin
    }
    
    func calculate(index: Int, views: [View]) -> Double {
        let maxCount = calculateMaxHorizontalCount(index: index, views: views)
        
        let maxViewObjectSizeWidthTotal: Double = viewObjectSizeWidth * Double(maxCount)
        let viewObjectHorizontalMarginTotal: Double = viewObjectHorizontalMargin * Double(maxCount - 1)
        
        return maxViewObjectSizeWidthTotal + viewObjectHorizontalMarginTotal
    }
    
    /*
     e.g 下記のように、水平方向にどれだけ長いかを算出するためのロジック
     ========================================
     0 1 2 3 4 5
       1 2 3
       1
     0 1 2 3
           3 4 5 6
           3 4 5
             4 5 6 7 8 → 8が最も水平方向に長い
     0
     0 1 2 3 4 5
           3 4 5
     ========================================
     */
    func calculateMaxHorizontalCount(index: Int, views: [View]) -> Int {
        var indexList: [Int] = [index + 1]
        
        views.forEach { view in
            if view.views.count > 0 {
                indexList.append(calculateMaxHorizontalCount(index: index + 1, views: view.views))
            }
        }
        
        return indexList.max() ?? index
    }
}
