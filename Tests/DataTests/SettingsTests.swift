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
        
        XCTContext.runActivity(named: "settings.transitionTypeListのデフォルト値の確認") { _ in
            let actual = settings.transitionTypeList
            let expectedCount = 0
            
            XCTAssertEqual(actual.count, expectedCount)
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
        XCTContext.runActivity(named: "updateViewObjectColor適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewObjectColor適用後") { _ in
            let settings = Settings()
            let inputColor = NSColor.red
            settings.updateViewObjectColor(inputColor)
            
            let actual = settings.viewObjectColor
            let expected = inputColor
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewObjectBorderColor() {
        XCTContext.runActivity(named: "updateViewObjectBorderColor適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewObjectBorderColor適用後") { _ in
            let settings = Settings()
            let inputColor = NSColor.green
            settings.updateViewObjectBorderColor(inputColor)
            
            let actual = settings.viewObjectBorderColor
            let expected = inputColor
                        
            XCTAssertEqual(actual, expected)
        }
    }
    
    func test_updateViewObjectTextColor() {
        XCTContext.runActivity(named: "updateViewObjectTextColor適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateViewObjectTextColor適用後") { _ in
            let settings = Settings()
            let inputColor = NSColor.blue
            settings.updateViewObjectTextColor(inputColor)
            
            let actual = settings.viewObjectTextColor
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
    
    func test_updateTransitionTypeList() {
        XCTContext.runActivity(named: "updateTransitionTypeList適用前") { _ in
            // test_initSettingsで検証済み
        }
        
        XCTContext.runActivity(named: "updateTransitionTypeList適用後") { _ in
            let settings = Settings()
            let inputTransionTypeList = [
                TransitionType(typeStr: "hoge", colorStr: "000011", isDefault: true),
                TransitionType(typeStr: "fuga", colorStr: "000012", isDefault: false),
                TransitionType(typeStr: "bar", colorStr: "000013", isDefault: true)
            ]
            
            settings.updateTransitionTypeList(inputTransionTypeList)
            
            let actual = settings.transitionTypeList
            let expected = inputTransionTypeList
                        
            XCTAssertEqual(actual[0].typeStr, expected[0].typeStr)
            XCTAssertEqual(actual[0].colorStr, expected[0].colorStr)
            XCTAssertEqual(actual[0].isDefault, expected[0].isDefault)
            XCTAssertEqual(actual[1].typeStr, expected[1].typeStr)
            XCTAssertEqual(actual[1].colorStr, expected[1].colorStr)
            XCTAssertEqual(actual[1].isDefault, expected[1].isDefault)
            XCTAssertEqual(actual[2].typeStr, expected[2].typeStr)
            XCTAssertEqual(actual[2].colorStr, expected[2].colorStr)
            XCTAssertEqual(actual[2].isDefault, expected[2].isDefault)
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
    
    func test_initSettingsTransionType() {
        XCTContext.runActivity(named: "初期化時に適切に値をセットできているかの確認") { _ in
            let typeStr = "push"
            let colorStr = "FFFFFF"
            let isDefault = true
            let actual = TransitionType(typeStr: typeStr, colorStr: colorStr, isDefault: isDefault)
            
            XCTAssertEqual(actual.typeStr, typeStr)
            XCTAssertEqual(actual.colorStr, colorStr)
            XCTAssertEqual(actual.isDefault, isDefault)
        }
    }
}
