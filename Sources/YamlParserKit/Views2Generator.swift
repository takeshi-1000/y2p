import Yaml
import Data

struct Views2Data {
    let view: View
    let viewsKeys: [String]
}

class Views2Generator {
    static func generate2(index: Int, viewsDicList: [Yaml : Yaml]) -> [View] {
        var _nestedViews: [View] = []
        
        var viewsList: [Views2Data] = []
        
        viewsDicList.forEach { viewsDic in
            var _nameKey: String = ""
            var _nameValue: String = ""
            var _urlStr: String = ""
            var _transitionTypeKey: String = ""
            var _contentColor: String = ""
            var _borderColor: String = ""
            var _isRoot: Bool = false
            var _viewsKeys: [String] = []
                        
            // viewsDicからViewに変換して全てをぶち込む
            
            if case .string(let viewNameKey) = viewsDic.key,
               case .dictionary(let viewInfoList) = viewsDic.value {
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
            }
            
            viewsList.append(
                Views2Data(
                    view: View(nameData: (key: _nameKey, value: _nameValue),
                               urlStr: _urlStr,
                               transitionTypeKey: _transitionTypeKey,
                               contentColor: _contentColor,
                               borderColor: _borderColor,
                               index: index,
                               isRoot: _isRoot,
                               views: []),
                    viewsKeys: _viewsKeys)
            )
        }
        
        let rootViews: [Views2Data] = viewsList
            .filter { $0.view.isRoot }
        
        rootViews.forEach { rootView in
            rootView.view.updateIndex(0)
            _nestedViews.append(rootView.view)
        }
                        
        testViews(views: rootViews, index: 0)
        
        func testViews(views: [Views2Data], index: Int) {
            views.forEach { view2Data in

                let _view = view2Data.view
                _view.updateIndex(index)

                let childViews: [Views2Data] = {
                    var _childViews: [Views2Data] = []
                    let keys = view2Data.viewsKeys
                    
                    keys.forEach { key in
                        if let _childView = viewsList.first(where: { $0.view.nameData.key == key }) {
                            _childViews.append(_childView)
                        }
                    }
                    
                    return _childViews
                }()
                
                _view.updateViews(childViews.map { $0.view })
                
                if childViews.isEmpty == false {
                    testViews(views: childViews, index: index + 1)
                }
            }
        }
        
        return _nestedViews
    }
}
