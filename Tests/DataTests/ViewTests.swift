import XCTest
@testable import Data

final class ViewTests: XCTestCase {
    let mockViewData: View = .init(nameData: (key: "ListView", value: "リスト"),
                                   urlStr: "https://www.youtube.com",
                                   contentColor: "123456",
                                   borderColor: "654321",
                                   index: 0,
                                   isRoot: false,
                                   views: [])
    
    func test_init() {
        XCTContext.runActivity(named: "初期化時に適切に値をセットできているかの確認") { _ in
            let nameData: (key: String, value: String) = ("SplashView", "スプラッシュ")
            let urlStr = "https://www.youtube.com"
            let contentColor: String = "FFFFFF"
            let borderColor: String = "000000"
            let index: Int = 4
            let isRoot: Bool = true
            let views: [View] = [mockViewData, mockViewData, mockViewData]
            
            let actual = View(nameData: nameData,
                              urlStr: urlStr,
                              contentColor: contentColor,
                              borderColor: borderColor,
                              index: index,
                              isRoot: isRoot,
                              views: views)
            
            XCTAssertEqual(actual.nameData.key, nameData.key)
            XCTAssertEqual(actual.nameData.value, nameData.value)
            XCTAssertEqual(actual.urlStr, urlStr)
            XCTAssertEqual(actual.contentColor, contentColor)
            XCTAssertEqual(actual.borderColor, borderColor)
            XCTAssertEqual(actual.index, index)
            XCTAssertEqual(actual.isRoot, isRoot)
            XCTAssertEqual(actual.views.count, views.count)
        }
        
        XCTContext.runActivity(named: "view.rectのデフォルト値の確認") { _ in
            let actual = mockViewData
            let expexted: NSRect = .zero
            
            XCTAssertEqual(actual.rect, expexted)
        }
    }
    
    func test_updateRect() {
        XCTContext.runActivity(named: "updateRect適用前") { _ in
            let view = mockViewData
            
            let actual = view.rect
            let expected: NSRect = .zero
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "updateRect適用後") { _ in
            let view = mockViewData
            let inputRect = NSRect(x: 100, y: 101, width: 102, height: 103)
            view.updateRect(inputRect)
            
            let actual = view.rect
            let expected = inputRect
                        
            XCTAssertEqual(actual, expected)
        }
    }
}
