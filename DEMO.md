## EView's demo

### Simple EView

```swift
eView = EView.serialization(in: view)
view.addSubview(eView)
```

<div display="block">
<img src="./ExpanderExample/Effects/only-original.png" width="375"/>
<img src="./ExpanderExample/Effects/only-expanded.png"/ width="375">
</div>

### Custom

```swift
/// Custom config
var config = EViewConfig()
config.located = .right
config.size = CGSize(width: 150, height: 150)
config.expandSize = CGSize(width: view.bounds.width - 16, height: 300)
eView.applyConfig(config)
```

<div display="block">
<img src="./ExpanderExample/Effects/config-original.png" width="375"/>
<img src="./ExpanderExample/Effects/config-expanded.png"/ width="375">
</div>

### Show datas

```swift
/// Show datas
let datas = [["title": "德国", "image": "GM.png"],
             ["title": "印度", "image": "IN.png"],
             ["title": "日本", "image": "JP.png"],
             ["title": "朝鲜", "image": "SK.png"],
             ["title": "荷兰", "image": "NL.png"],
             ["title": "英国", "image": "UK.png"],
             ["title": "美国", "image": "US.png"],
             ["title": "加拿大", "image": "CA.png"],
             ["title": "新加坡", "image": "SP.png"]]

/// Cell's config
let cellConfig = EViewCellConfig(keys: ["title", "image"])
eView.showDatas(datas, with: cellConfig) { (idx) in
    print("Selected: \(idx)")
}
```

<div display="block">
<img src="./ExpanderExample/Effects/only-original.png" width="375"/>
<img src="./ExpanderExample/Effects/datas-expanded.png"/ width="375">
</div>

### Combine custom with show datas

<div display="block">
<img src="./ExpanderExample/Effects/config-original.png" width="375"/>
<img src="./ExpanderExample/Effects/config-datas-expanded.png"/ width="375">
</div>

Custom cell's size

```swift
/// Cell's config
let cellConfig = EViewCellConfig(keys: ["title", "image"])
let layout = UICollectionViewFlowLayout()
let wh = (view.bounds.width - 16 - 20) / 4
layout.itemSize = CGSize(width: wh, height: wh)
layout.minimumLineSpacing = 4
layout.minimumInteritemSpacing = 4
cellConfig.layout = layout
eView.showDatas(datas, with: cellConfig) { (idx) in
    print("Selected: \(idx)")
}
```

<div display="block">
<img src="./ExpanderExample/Effects/config-original.png" width="375"/>
<img src="./ExpanderExample/Effects/custom-config-datas-expanded.png"/ width="375">
</div>

### Use `EViewGroup` to manager `EViews`

```swift
let centerLine = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 1))
centerLine.backgroundColor = .orange
centerLine.center = view.center
view.addSubview(centerLine)

let view1 = EView.serialization(in: view)
var view1Config = EViewConfig()
view1Config.located = .right
view1Config.expandSize = CGSize.init(width: view.bounds.width - 16, height: 600)
view1.applyConfig(view1Config)

let view2 = EView.serialization(in: view)
let view3 = EView.serialization(in: view)
let view4 = EView.serialization(in: view)
eGroup = EViewGroup.init(layout: .end, mode: .clever, with: view1, view2, view3, view4)
eGroup.interItemSpacing = 8
eGroup.formed()
```
layout: `.start`, `.center`, `.end`, `.spaceBetween`, `.spaceAround`

<div display="block">
<img src="./ExpanderExample/Effects/group-start.png" width="375"/>
<img src="./ExpanderExample/Effects/group-center.png"/ width="375">
<img src="./ExpanderExample/Effects/group-end.png"/ width="375">
<img src="./ExpanderExample/Effects/group-spacebetween.png"/ width="375">
<img src="./ExpanderExample/Effects/group-spacearound.png"/ width="375">
</div>