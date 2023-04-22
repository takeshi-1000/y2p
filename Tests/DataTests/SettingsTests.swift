import XCTest
@testable import Data

final class SettingsTests: XCTestCase {
    func test_initSettings() {
        let settings = Settings()
                
        XCTContext.runActivity(named: "settings.viewObjectSizeのデフォルト値の確認") { _ in
            let actual = settings.viewObjectSize
            let expected = NSSize(width: 100, height: 50)
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.viewObjectColorのデフォルト値の確認") { _ in
            let actual = settings.viewObjectColor
            let expected = NSColor.white
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.viewObjectBorderColorのデフォルト値の確認") { _ in
            let actual = settings.viewObjectBorderColor
            let expected = NSColor.black
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.viewObjectTextColorのデフォルト値の確認") { _ in
            let actual = settings.viewObjectTextColor
            let expected = NSColor.black
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.viewObjectTextFontSizeのデフォルト値の確認") { _ in
            let actual = settings.viewObjectTextFontSize
            let expected: Double = 20
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.viewVerticalMarginのデフォルト値の確認") { _ in
            let actual = settings.viewVerticalMargin
            let expected: Double = 20
            
            XCTAssertEqual(actual, expected)
        }

        XCTContext.runActivity(named: "settings.viewHorizontalMarginのデフォルト値の確認") { _ in
            let actual = settings.viewHorizontalMargin
            let expected: Double = 50
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.marginのデフォルト値の確認") { _ in
            let actual = settings.margin
            let expected: Double = 16
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.imageNameのデフォルト値の確認") { _ in
            let actual = settings.imageName
            let expected = "transition.png"
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.defaultTransitionTypeKeyのデフォルト値の確認") { _ in
            let actual = settings.defaultTransitionTypeKey
            let expected = ""
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.transitionTypeListのデフォルト値の確認") { _ in
            let actual = settings.transitionTypeList
            let expectedCount = 0
            
            XCTAssertEqual(actual.count, expectedCount)
        }
        
        XCTContext.runActivity(named: "settings.slashWidthのデフォルト値の確認") { _ in
            let actual = settings.slashWidth
            let expected: Double = 1
            
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_initSettingsTransionType() {
        XCTContext.runActivity(named: "初期化時に適切に値をセットできているかの確認") { _ in
            let typeStr = "push"
            let colorStr = "FFFFFF"
            let actual = TransitionType(typeStr: typeStr, colorStr: colorStr)
            
            XCTAssertEqual(actual.typeStr, typeStr)
            XCTAssertEqual(actual.colorStr, colorStr)
        }
    }
}
