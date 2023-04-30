import Data
import Foundation
import Yaml

public class YamlParser {
    public var views: [View] { _views }
    public var settings: Settings { _settings }
    public var views2: [View] { _views2 }
    
    private var _views: [View] = []
    private var _settings: Settings = .init()
    private var _views2: [View] = []
    
    public init() {}
    
    public func parse(fileURL: URL) throws {
        let contents = try String(contentsOf: fileURL, encoding: .utf8)
        let value = try Yaml.load(contents)
        
        let dictionaries: ([Yaml : Yaml]) = {
            if case .dictionary(let dictionaries) = value {
                return dictionaries
            }
            return ([:])
        }()
        
        var startIndex = dictionaries.startIndex
        
        while dictionaries.endIndex > startIndex {
            
            let dictionary = dictionaries[startIndex]
            
            if dictionary.key == .string("views"), case .array(let viewsArray) = dictionary.value {
                _views = ViewsGenerator.generate(index: 0, viewsArray: viewsArray)
            }
            
            if dictionary.key == .string("views2"), case .dictionary(let viewsDicList) = dictionary.value {
                _views2 = Views2Generator.generate2(index: 0, viewsDicList: viewsDicList)
            }
            
            if dictionary.key == .string("settings"), case .dictionary(let settingsDictionary) = dictionary.value {
                _settings = SettingsGenerator.generate(settingsInfoList: settingsDictionary)
            }
            
            startIndex = dictionaries.index(after: startIndex)
        }
    }
}
