import Yaml
import Data
import Cocoa

/// yaml parser for `views`
class ViewsGenerator {
    static func generate(index: Int, viewsArray: [Yaml]) -> [View] {
        var _views: [View] = []
        
        viewsArray.forEach { viewData in
            var _nameKey: String = ""
            var _nameValue: String = ""
            var _urlStr: String = ""
            var _transitionTypeKey: String = ""
            var _contentColor: String = ""
            var _borderColor: String = ""
            var _childviews: [View] = []
            
            if case .dictionary(let viewsDataDictionaries) = viewData {
                viewsDataDictionaries.forEach { viewsDataDictionary in
                    if case .string(let viewNameKey) = viewsDataDictionary.key,
                       case .dictionary(let viewInfoList) = viewsDataDictionary.value {
                        _nameKey = viewNameKey
                        
                        viewInfoList.forEach { viewInfo in
                            if case .string("name") = viewInfo.key,
                               case .string(let viewNameValue) = viewInfo.value {
                                _nameValue = viewNameValue
                            }
                            if case .string("url") = viewInfo.key,
                               case .string(let urlStr) = viewInfo.value {
                                _urlStr = urlStr
                            }
                            if case .string("transitionType") = viewInfo.key,
                               case .string(let transitionTypeKey) = viewInfo.value {
                                _transitionTypeKey = transitionTypeKey
                            }
                            if case .string("contentColor") = viewInfo.key,
                               case .string(let contentColor) = viewInfo.value {
                                _contentColor = contentColor
                            }
                            if case .string("borderColor") = viewInfo.key,
                               case .string(let borderColor) = viewInfo.value {
                                _borderColor = borderColor
                            }
                            
                            if case .string("views") = viewInfo.key,
                               case .array(let childViews) = viewInfo.value {
                                _childviews = generate(index: index + 1, viewsArray: childViews)
                            }
                        }
                    }
                }
            }
            
            _views.append(
                View(nameData: (key: _nameKey, value: _nameValue),
                     urlStr: _urlStr,
                     transitionTypeKey: _transitionTypeKey,
                     contentColor: _contentColor,
                     borderColor: _borderColor,
                     index: index,
                     isRoot: false,
                     views: _childviews)
            )
        }
        
        return _views
    }
}
