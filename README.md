## Expander

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![Platform](https://img.shields.io/badge/platform-iOS-4BC51D.svg) ![Swift](https://img.shields.io/badge/Swift-4.2-4BC51D.svg)


## Installation

### Carthage
Install [Carthage](https://github.com/Carthage/Carthage) if need be.

```
$ brew update
$ brew install carthage
```

Add `Expander` in your `Cartfile`.

```
github "yutingLei/Expander" "master"
```

Run `carthage` to build the framework and drag the built `Expander.framework` into your Xcode project.

### Manual
Copy `Expander` folder to your project. That's it.

_**Note:** If you encounter issues while uploading the app to iTunes Connect, remove the `Info.plist` file in `Expander`._


## Usage

Firstly, import `Expaner`.

```swift
import Expander
```

### Initialization

Then, there is only one way you can create `EView`:

```swift
/// The view is the EView's superview
/// Don't care about memory leak. use `weak` refrencens when using `view`.
let eView = EView.serialization(in: view)
view.addSubview(eView)
```

### Custom config `EView`
*If you don't like to configure this view, you can skip it directly.*

Instance a config object. you should know that the type `EViewConfig` is `struct`.

```swift
var config = EViewConfig()
```

Set EView's original size. default is `80x80`

```swift
config.size = CGSize.init(width: <#width#>, height: <#height#>)
```

Set EView's expanded size. it must greater than original `size`  
Default is: `height=120`, `width=superviwe's width`

```swift
config.expandSize = CGSize.init(width: <#width#>, height: <#height#>)
```

Set others properties.

```swift
/// The corner radius when EView expanded. Optional
/// If not set, default is 10
config.expandCornerRadius = <#radius#>

/// Decide how long distance to superview's top. Optional
/// If not set, EView's midY = superview.center.y
config.distanceToTop = <#distance#>

/// Decide padding to superview. Optional
/// If not set, padding top/left/bottom/right = 8
config.padding = <#EViewPadding(8)#>

/// Decide which direction will be selected when expanding. Optional
/// If not set, Default `.center`
config.expandType = .center

/// Decide where the EView located. Optional
/// If not set, Default `.left`
config.located = .left

/// The expand/fold action's title. Optional
/// If not set, default `(Expand, Fold)`
config.located = ("展开", "收拢")
```

Apply configurations.

```swift
eView.applyConfig(config)
```

## Extension

### How can i control EView's actions?

There are two methods that can control EView's actions.

```swift
/// Expand action
public func expand()
/// Fold action
public func fold()
```

### How to show myself custom view?

When created `EView`, a property named `contentView` that you can got it.  
Then, you can add any view into `contentView`.

### How to show datas fastly?

Firstly, we have an array that contain our datas.

```swift
let datas = [["title": "德国", "image": "GM.png"],
            ["title": "印度", "image": "IN.png"],
            ["title": "日本", "image": "JP.png"],
            ["title": "朝鲜", "image": "SK.png"],
            ["title": "荷兰", "image": "NL.png"],
            ["title": "英国", "image": "UK.png"],
            ["title": "美国", "image": "US.png"],
            ["title": "加拿大", "image": "CA.png"],
            ["title": "新加坡", "image": "SP.png"]]
```

Init configuration with `EViewCellConfig`:

```swift
/// Init config
/// Note: the first key must be title's key, the second key must be image's key
let cellConfig = EViewCellConfig(keys: ["title", "image"])
```

Set others properties. also you can skip it directly.

```swift
/// The cell's mode to decide which style will be used to layout subviews.
/// .`default`: top title, bottom image
/// .classic:   top image, bottom title
/// If not set, default is .`default`
cellConfig.mode = .`default`

/// Wether support multiple select.
/// If not set, default is false
cellConfig.isMultiSelect = <#Bool-value#>

/// The title for sure button. (Only for multiple select). Optional
cellConfig.sureTitle = <#title-string#>

/// The sure button's callback when touched. Optional
cellConfig.multiSelectHandler = { idxs in print("Selected idxs: \(idxs)") }

/// Cell's background color
/// Default is .white
cellConfig.backgroundColor = .white

/// Cell's background color when selected. Optioanl
/// (Only for single select)
cellConfig.selectedBackgroundColor = <#UIColor#>

/// A image flag for selected cell. Optional
/// (Only for multiple select)
cellConfig.selectedImage = <#UIImage#>

/// Layout for cell. Optional
let layout = UICollectionViewFlowLayout()
layout...
cellConfig.layout = layout
```

Show datas.

```swift
eView.showDatas(datas, with: config) { idx in print("Current select: \(idx)")}
```

## [Demo](./demo.md)



## TODO
- [x] 实现基础功能 
- [ ] 添加重力感应  
- [ ] flex创建方式  

