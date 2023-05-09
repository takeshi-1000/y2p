import Yaml
import Data

class ViewsGenerator {
    
    static func generate(viewsDicList: [Yaml : Yaml]) -> [View] {
        
        var nestedViews: [View] = []
        var nestedViewKeys: [String] = []
        var separatedViewKeys: [String] = []
        
        viewsDicList.forEach { viewsDic in
            if case .string(let nameKey) = viewsDic.key,
               case .dictionary(let viewInfoList) = viewsDic.value {

                viewInfoList.forEach { viewInfo in
                    if case .string("isRoot") = viewInfo.key,
                       case .bool(let isRoot) = viewInfo.value {
                        if isRoot {
                            nestedViews.append(
                                generateView(key: nameKey, infoList: viewInfoList, index: 0)
                            )
                        }
                    }
                }
            }
        }
        
        // separateしたViewの方が先に生成されるのでリバースする
        return nestedViews.reversed()
        
        func generateView(key: String, infoList: [Yaml : Yaml], index: Int) -> View {
            var _nameValue: String = ""
            var _urlStr: String = ""
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
                    _urlStr = urlStr.replacingOccurrences(of: "&", with: "&amp;")
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
                    
                    // 毎回childViewsを見なくて良い
                    // (a)keyがviewsとして何箇所使われているか
                    // (b)そのkeyのviewの遷移先があるか
                    // (a)と(b)だった場合、そのkeyの遷移先を切り出してnestedViewsに追加する
                    // すでにnestedViewに追加されている場合は追加しない
                    // TODO: ここのロジックきつい
                    if shouldSeparate(key: key) {
                        if index == 0 {
                            if separatedViewKeys.contains(where: { $0 == key }) == false {
                                separatedViewKeys.append(key)
                                childViews.forEach { childViewKey in
                                    if case .string(let childViewKey) = childViewKey {
                                        _viewsKeys.append(childViewKey)
                                    }
                                }
                            }
                        } else {
                            if nestedViewKeys.contains(where: { $0 == key }) == false {
                                nestedViewKeys.append(key)
                                nestedViews.append(
                                    generateView(key: key,
                                                 infoList: getInfoListTargetView(key: key),
                                                 index: 0)
                                )
                            }
                        }
                    } else {
                        childViews.forEach { childViewKey in
                            if case .string(let childViewKey) = childViewKey {
                                _viewsKeys.append(childViewKey)
                            }
                        }
                    }
                }
            }
            
            return View(nameData: (key: key, value: _nameValue),
                        urlStr: _urlStr,
                        contentColor: _contentColor,
                        borderColor: _borderColor,
                        index: index,
                        isRoot: _isRoot,
                        views: generateViews(index: index + 1, viewKeys: _viewsKeys))
        }
        
        func generateViews(index: Int, viewKeys: [String]) -> [View] {
            var _views: [View] = []
            
            viewKeys.forEach { viewKey in
                viewsDicList.forEach { viewsDic in
                    if case .string(viewKey) = viewsDic.key,
                       case .dictionary(let viewInfoList) = viewsDic.value {
                        _views.append(
                            generateView(key: viewKey, infoList: viewInfoList, index: index)
                        )
                    }
                }
            }
            return _views
        }
        
        func shouldSeparate(key: String) -> Bool {
            var transionCount = 0
            
            for viewsDic in viewsDicList {
                // 余計なループを無くす
                if transionCount > 1 {
                    break
                }
                
                if case .string = viewsDic.key,
                   case .dictionary(let viewInfoList) = viewsDic.value {

                    viewInfoList.forEach { viewInfo in
                        if case .string("views") = viewInfo.key,
                           case .array(let array) = viewInfo.value {
                            
                            array.forEach { arrayItem in
                                if case .string(key) = arrayItem {
                                    transionCount += 1
                                }
                            }
                        }
                    }
                }
            }
            
            return transionCount > 1
        }
        
        func getInfoListTargetView(key: String) -> [Yaml : Yaml] {
            for viewsDic in viewsDicList {
                if case .string(key) = viewsDic.key,
                   case .dictionary(let viewInfoList) = viewsDic.value {
                    return viewInfoList
                }
            }
            return [:]
        }
    }
}
