import Data

public class ImageWidthCalculator {
    private let viewObjectSizeWidth: Double
    private let viewObjectHorizontalMargin: Double
    
    public init(viewObjectSizeWidth: Double, viewObjectHorizontalMargin: Double) {
        self.viewObjectSizeWidth = viewObjectSizeWidth
        self.viewObjectHorizontalMargin = viewObjectHorizontalMargin
    }
    
    public func calculate(index: Int, viewsArray: [View]) -> Double {
        let maxCount = calculateMaxHorizontalCount(index: index, viewsArray: viewsArray)
        
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
    func calculateMaxHorizontalCount(index: Int, viewsArray: [View]) -> Int {
        var indexList: [Int] = [index + 1]
        
        viewsArray.forEach { view in
            if view.views.count > 0 {
                indexList.append(calculateMaxHorizontalCount(index: index + 1, viewsArray: view.views))
            }
        }
        
        return indexList.max() ?? index
    }
}
