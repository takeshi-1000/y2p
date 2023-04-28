import Yaml
import Data
import Cocoa
import Utility

/// yaml parser for `settings`
class SettingsGenerator {
    static func generate(settingsInfoList: [Yaml : Yaml]) -> Settings {
        let _settings = Settings()
            
        settingsInfoList.forEach { settings in
            
            if case .string("margin") = settings.key,
               case .int(let margin) = settings.value {
                _settings.updateMargin(Double(margin))
            }
            
            if case .string("slashWidth") = settings.key,
               case .int(let slashWidth) = settings.value {
                _settings.updateSlashWidth(Double(slashWidth))
            }
            
            if case .string("transitionTypeList") = settings.key,
               case .array(let transitionTypeList) = settings.value {
                var _transitionTypeList: [TransitionType] = []
                
                transitionTypeList.forEach { yaml in
                    if case .dictionary(let transitionTypeInfoList) = yaml {
                        
                        transitionTypeInfoList.forEach { transitionTypeInfoData in
                            var _transitionTypeTypeStr: String = ""
                            var _transitionTypeColorStr: String = ""
                            var _transitionTypeIsDefault: Bool = false
                            
                            if case .string(let type) = transitionTypeInfoData.key {
                                _transitionTypeTypeStr = type
                            }
                            if case .dictionary(let transitionTypeInfoDic) = transitionTypeInfoData.value {
                                transitionTypeInfoDic.forEach { transitionTypeInfo in
                                    if case .string("color") = transitionTypeInfo.key,
                                       case .string(let colorStr) = transitionTypeInfo.value {
                                        _transitionTypeColorStr = colorStr
                                    }
                                    
                                    if case .string("isDefault") = transitionTypeInfo.key,
                                       case .bool(let isDefault) = transitionTypeInfo.value {
                                        _transitionTypeIsDefault = isDefault
                                    }
                                }
                            }
                            _transitionTypeList.append(
                                TransitionType(
                                    typeStr: _transitionTypeTypeStr,
                                    colorStr: _transitionTypeColorStr,
                                    isDefault: _transitionTypeIsDefault
                                )
                            )
                        }
                    }
                }
                
                _settings.updateTransitionTypeList(_transitionTypeList)
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
                        _settings.updateViewObjectTextColor(NSColor(hex: textColorHexCode))
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
