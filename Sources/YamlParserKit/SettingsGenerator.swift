import Yaml
import Data
import Cocoa

/// yaml parser for `settings`
class SettingsGenerator {
    static func generate(settingsInfoList: [Yaml : Yaml]) -> Settings {
        let _settings = Settings()
            
        settingsInfoList.forEach { settings in
            
            if case .string("margin") = settings.key,
               case .int(let margin) = settings.value {
                _settings.updateMargin(Double(margin))
            }
            
            if case .string("lineWidth") = settings.key,
               case .int(let lineWidth) = settings.value {
                _settings.updateLineWidth(Double(lineWidth))
            }
            
            if case .string("showGuideLines") = settings.key,
               case .bool(let showGuideLines) = settings.value {
                _settings.updateShowGuideLines(showGuideLines)
            }
            
            if case .string("object") = settings.key,
               case .dictionary(let objectInfoDictionaryArray) = settings.value {
                
                objectInfoDictionaryArray.forEach { objectInfoDic in
                    if case .string("verticalMargin") = objectInfoDic.key,
                       case .int(let verticalMargin) = objectInfoDic.value {
                        _settings.updateViewVerticalMargin(Double(verticalMargin))
                    }
                    if case .string("horizontalMargin") = objectInfoDic.key,
                       case .int(let horizontalMargin) = objectInfoDic.value {
                        _settings.updateViewHorizontalMargin(Double(horizontalMargin))
                    }
                    if case .string("contentColor") = objectInfoDic.key,
                       case .string(let contentColorHexCode) = objectInfoDic.value {
                        _settings.updateViewObjectColorStr(contentColorHexCode)
                    }
                    if case .string("textColor") = objectInfoDic.key,
                       case .string(let textColorHexCode) = objectInfoDic.value {
                        _settings.updateViewObjectTextColorStr(textColorHexCode)
                    }
                    if case .string("fontSize") = objectInfoDic.key,
                       case .int(let fontSize) = objectInfoDic.value {
                        _settings.updateViewObjectTextFontSize(Double(fontSize))
                    }
                    if case .string("enabledRoundCorner") = objectInfoDic.key,
                       case .bool(let enabledRoundCorner) = objectInfoDic.value {
                        _settings.updateEnabledRoundCorner(enabledRoundCorner)
                    }
                    if case .string("size") = objectInfoDic.key,
                       case .dictionary(let sizeDictionaries) = objectInfoDic.value {
                        
                        sizeDictionaries.forEach { sizeDic in
                            var _size: NSSize = _settings.viewObjectSize
                            
                            if case .string("width") = sizeDic.key,
                               case .int(let width) = sizeDic.value {
                                _size.width = Double(width)
                                
                            }
                            
                            if case .string("height") = sizeDic.key,
                               case .int(let height) = sizeDic.value {
                                _size.height = Double(height)
                            }
                            
                            _settings.updateViewObjectSize(_size)
                        }
                    }
                }
            }
        }
            
        return _settings
    }
}
