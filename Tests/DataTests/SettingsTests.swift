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
        
        XCTContext.runActivity(named: "settings.viewObjectColorStrのデフォルト値の確認") { _ in
            let actual = settings.viewObjectColorStr
            let expected = "FFFFFF"
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.viewObjectBorderColorStrのデフォルト値の確認") { _ in
            let actual = settings.viewObjectBorderColorStr
            let expected = "000000"
            
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "settings.viewObjectTextColorStrのデフォルト値の確認") { _ in
            let actual = settings.viewObjectTextColorStr
            let expected = "000000"
            
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
        
        XCTContext.runActivity(named: "settings.lineWidthのデフォルト値の確認") { _ in
            let actual = settings.lineWidth
            let expected: Double = 1
            
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewObjectSize() {
        XCTContext.runActivity(named: "updateViewObjectSize適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewObjectSize適用後") { _ in
            let settings = Settings()
            let inputSize = NSSize(width: 100, height: 101)
            settings.updateViewObjectSize(inputSize)
            
            let actual = settings.viewObjectSize
            let expected = inputSize
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewObjectColor() {
        XCTContext.runActivity(named: "updateViewObjectColorStr適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewObjectColorStr適用後") { _ in
            let settings = Settings()
            let inputColor = "008000"
            settings.updateViewObjectColorStr(inputColor)
            
            let actual = settings.viewObjectColorStr
            let expected = inputColor
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewObjectBorderColor() {
        XCTContext.runActivity(named: "updateViewObjectBorderColorStr適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewObjectBorderColorStr適用後") { _ in
            let settings = Settings()
            let inputColor = "008000"
            settings.updateViewObjectBorderColorStr(inputColor)
            
            let actual = settings.viewObjectBorderColorStr
            let expected = inputColor
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewObjectTextColor() {
        XCTContext.runActivity(named: "updateViewObjectTextColorStr適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewObjectTextColorStr適用後") { _ in
            let settings = Settings()
            let inputColor = "008000"
            settings.updateViewObjectTextColorStr(inputColor)
            
            let actual = settings.viewObjectTextColorStr
            let expected = inputColor
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewObjectTextFontSize() {
        XCTContext.runActivity(named: "updateViewObjectTextFontSize適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewObjectTextFontSize適用後") { _ in
            let settings = Settings()
            let inputFontSize: Double = 30
            settings.updateViewObjectTextFontSize(inputFontSize)
            
            let actual = settings.viewObjectTextFontSize
            let expected = inputFontSize
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewVerticalMargin() {
        XCTContext.runActivity(named: "updateViewVerticalMargin適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewVerticalMargin適用後") { _ in
            let settings = Settings()
            let inputMargin: Double = 28
            settings.updateViewVerticalMargin(inputMargin)
            
            let actual = settings.viewVerticalMargin
            let expected = inputMargin
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewHorizontalMargin() {
        XCTContext.runActivity(named: "updateViewHorizontalMargin適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewHorizontalMargin適用後") { _ in
            let settings = Settings()
            let inputMargin: Double = 26
            settings.updateViewHorizontalMargin(inputMargin)
            
            let actual = settings.viewHorizontalMargin
            let expected = inputMargin
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateMargin() {
        XCTContext.runActivity(named: "updateMargin適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateMargin適用後") { _ in
            let settings = Settings()
            let inputMargin: Double = 24
            settings.updateMargin(inputMargin)
            
            let actual = settings.margin
            let expected = inputMargin
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateLineWidth() {
        XCTContext.runActivity(named: "updateLineWidth適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateLineWidth適用後") { _ in
            let settings = Settings()
            let inputWidth: Double = 4
            settings.updateLineWidth(inputWidth)
            
            let actual = settings.lineWidth
            let expected = inputWidth
                        
            XCTAssertEqual(actual, expected)
        }
    }
}
