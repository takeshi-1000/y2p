import XCTest
@testable import Data

final class ViewTests: XCTestCase {
    let mockViewData: View = .init(nameData: (key: "ListView", value: "リスト"),
                                   transitionTypeKey: "modal",
                                   contentColor: "123456",
                                   borderColor: "654321",
                                   index: 0,
                                   views: [])
    
    func test_init() {
        let nameData: (key: String, value: String) = ("SplashView", "スプラッシュ")
        let transitionTypeKey: String = "push"
        let contentColor: String = "FFFFFF"
        let borderColor: String = "000000"
        let index: Int = 4
        let views: [View] = [mockViewData, mockViewData, mockViewData]
        
        let actual = View(nameData: nameData,
                          transitionTypeKey: transitionTypeKey,
                          contentColor: contentColor,
                          borderColor: borderColor,
                          index: index,
                          views: views)
        
        XCTAssertEqual(actual.nameData.key, nameData.key)
        XCTAssertEqual(actual.nameData.value, nameData.value)
        XCTAssertEqual(actual.transitionTypeKey, transitionTypeKey)
        XCTAssertEqual(actual.contentColor, contentColor)
        XCTAssertEqual(actual.borderColor, borderColor)
        XCTAssertEqual(actual.index, index)
        XCTAssertEqual(actual.views.count, views.count)
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
