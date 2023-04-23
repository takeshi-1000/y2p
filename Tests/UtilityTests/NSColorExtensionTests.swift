import XCTest
@testable import Utility

final class NSColorExtensionTests: XCTestCase {
    func testConvenienceInit() {
        XCTContext.runActivity(named: "alphaの値確認") { _ in
            XCTContext.runActivity(named: "alpha指定あり") { _ in
                let alpha: Double = 0.45
                let hex = "FFFFFF"
                let actual = NSColor(hex: hex, alpha: alpha)
                
                XCTAssertEqual(actual.alphaComponent, alpha)
            }
            XCTContext.runActivity(named: "alpha指定なし") { _ in
                let hex = "FFFFFF"
                let actual = NSColor(hex: hex)
                let expectedAlpha: Double = 1.0
                
                XCTAssertEqual(actual.alphaComponent, expectedAlpha)
            }
        }
        
        XCTContext.runActivity(named: "hexが正しくrgbに変換できているかの確認") { _ in
            // TODO: 
        }
    }
}
