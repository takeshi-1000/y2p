import Yaml
import Data

class Views2Generator {
    
    static func generate2(viewsDicList: [Yaml : Yaml]) -> [View] {
        
        var nestedViews: [View] = []
        
        viewsDicList.forEach { viewsDic in
            if case .string(let nameKey) = viewsDic.key,
               case .dictionary(let viewInfoList) = viewsDic.value {

                viewInfoList.forEach { viewInfo in
                    if case .string("isRoot") = viewInfo.key,
                       case .bool(let isRoot) = viewInfo.value {
                        if isRoot {
                            nestedViews.append(
                                createView(key: nameKey, infoList: viewInfoList, index: 0)
                            )
                        }
                    }
                }
            }
        }
                
        return nestedViews
        
        func createView(key: String, infoList: [Yaml : Yaml], index: Int) -> View {
            var _nameValue: String = ""
            var _urlStr: String = ""
            var _transitionTypeKey: String = ""
            var _contentColor: String = ""
            var _borderColor: String = ""
            var _isRoot: Bool = false
            var _viewsKeys: [String] = []
            
            infoList.forEach { viewInfo in
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
                if case .string("isRoot") = viewInfo.key,
                   case .bool(let isRoot) = viewInfo.value {
                    _isRoot = isRoot
                }
                
                if case .string("views") = viewInfo.key,
                   case .array(let childViews) = viewInfo.value {
                    childViews.forEach { childViewKey in
                        if case .string(let childViewKey) = childViewKey {
                            _viewsKeys.append(childViewKey)
                        }
                    }
                }
            }
            
            return View(nameData: (key: key, value: _nameValue),
                        urlStr: _urlStr,
                        transitionTypeKey: _transitionTypeKey,
                        contentColor: _contentColor,
                        borderColor: _borderColor,
                        index: index,
                        isRoot: _isRoot,
                        views: calcViews(viewKeys: _viewsKeys))
            
            func calcViews(viewKeys: [String]) -> [View] {
                var _views: [View] = []
                
                viewKeys.forEach { viewKey in
                    viewsDicList.forEach { viewsDic in
                        if case .string(viewKey) = viewsDic.key,
                           case .dictionary(let viewInfoList) = viewsDic.value {
                            _views.append(
                                createView(key: viewKey, infoList: viewInfoList, index: index + 1)
                            )
                        }
                    }
                }
                return _views
            }
        }
    }
}
