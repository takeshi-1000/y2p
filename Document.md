## settings

In the `settings` section, you can define the overall style of the screen transition diagram.

e.g.

```
settings:
  object:
   borderColor: "000000"
   contentColor: "FFFFFF"
   textColor: "000000"
   fontSize: 13
   verticalMargin: 30
   horizontalMargin: 100
   enabledRoundCorner: true
   size:
    width: 100
    height: 50
  margin: 16
  lineWidth: 1
  showGuideLines: false
```

- settings: 
  - object: Configuration for the screen objects displayed in the diagram.
    - borderColor: Specifies the color of the object's border.
    - contentColor: Specifies the color of the object's content.
    - textColor: Specifies the color of the text within the object.
    - fontSize: Specifies the font size of the text within the object.
    - verticalMargin: Specifies the vertical margin between objects.
    - horizontalMargin: Specifies the horizontal margin between objects.
    - enabledRoundCorner: Specifies whether to round the corners.
    - size: Configuration for the size of the screen objects.
      - width: Specifies the width of the object.
      - height: Specifies the height of the object.
  - margin: Specify the outer margin for the top, bottom, left, and right of the screen diagram.
  - lineWidth: Specifies the thickness of the lines.
  - showGuideLines: Specifies whether to display guide lines (true for display, false for hide).

## views

In the `views` section, you can define each screen in the screen transition diagram.

e.g. 

```
views:
 Splash:
  name: "Splash"
  url: "https://www.google.com"
  isRoot: true
  contentColor: "D5E8D4"
  borderColor: "82B366"
  views:
   - FooView
   - BarView
 FooView:
  name: "Foo"
  url: "https://www.youtube.com"
  contentColor: "DAE8FC"
  borderColor: "6C8EBF"
 BarView:
  name: "Bar"
  contentColor: "DAE8FC"
  borderColor: "6C8EBF"
```

- views:
  - {View1}: This is a view key
    - name: View1 name
    - isRoot: Specify whether view1 is the root. You need to specify true for one view. 
    - url: View1 URL. When the URL is set, the screen object becomes clickable as a link. 
    - contentColor: Specifies the color of the text within the view1. When this setting is applied, it overrides the values in the settings section.
    - borderColor: Specifies the color of the object's border. When this setting is applied, it overrides the values in the settings section.
    - views:
      - {SubView1}: this is view key
      - {SubView2}:
      - {SubView3}: 
  - {View2}: this is a view key
