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
/// Don't care about memory leak. We used `weak` refrencens when using `view`.
let eView = EView.serialization(in: view)
view.addSubview(eView)
```

### Custom config `EView`
*If you don't like to configure this view, you can skip it directly.*

Instance a config object. you should know that the type `EViewConfig` is `struct`.

```swift
var config = EViewConfig()
```
Configuration properties:

| Property name | Type | Description | Default value |
| :-----------: | :--: | :--------- | :-----------: |
| size | CGSize | The original size of EView | `80x80` |
| expandSize | CGSize | The expanded size of EView | `Optional` |
| expandCornerRadius | CGFloat | The corner radius when EView expanded | `10` |
| distanceToTop | CGFloat | The distance to parent view | `Optional` |
| padding | EViewPadding | Padding to parent view | `EViewPadding(0, 8)` |
| expandType | [EViewExpandType](https://github.com/yutingLei/Expander/blob/d9f57eb52fb4fe9f019bc07290fc62dd89c1a1b3/Expander/EViewConfig.swift#L18) | How style will be used while expanding | `.center` |
| located | [EViewLocated](https://github.com/yutingLei/Expander/blob/d9f57eb52fb4fe9f019bc07290fc62dd89c1a1b3/Expander/EViewConfig.swift#L25) | Arrange EView at it's parent view's left/right  | `.left` |
| stateFlag | Touple | The text that decide state | `("Expand", "Fold")` |
| isViscosity | Bool | If true, The EView can be moved and return back original position when released | `Optional` |

After configuration, you must call the `applyConfig` function once.

```swift
eView.applyConfig(config)
```

## Extension

### I want to control the `Expand` and `Fold` actions myself?

There are two methods that can control EView's actions.

```swift
/// Expand action
/// rect: if you set, replace it with `expandSize`
public func expand(to rect: CGRect? = nil)
/// Fold action
/// rect: if you set, replace it with `size`
public func fold(to rect: CGRect? = nil)
```

### I want to add some views into EView

When created `EView`, a property named `contentView` that you can get it.  
Then, you can add any view into `contentView`.

### Is there a quick way to display data?

Of course, just a little code.  
Firstly, Suppose array data as follow:

```swift
let datas = [["title": "Gemany", "image": "GM.png"],
            ["title": "India", "image": "IN.png"],
            ["title": "Japan", "image": "JP.png"],
            ["title": "Netherlands", "image": "NL.png"],
            ["title": "UK", "image": "UK.png"],
            ["title": "US", "image": "US.png"],
            ["title": "Canada", "image": "CA.png"],
            ["title": "Singapore", "image": "SP.png"]]
```

Init configuration using `EViewCellConfig`:

```swift
/// Init config
/// Note: the first key must be title's key, the second key must be image's key
let cellConfig = EViewCellConfig(keys: ["title", "image"])
```

Set others properties. *also you can skip it directly.*

| Property name | Type | Description | Default value |
| :-----------: | :--: | :--------- | :-----------: |
| mode | [EViewCellMode](https://github.com/yutingLei/Expander/blob/d9f57eb52fb4fe9f019bc07290fc62dd89c1a1b3/Expander/EViewConfig.swift#L91) | Decide display style | `.default`, other is `.classic`|
| isMultiSelect | Bool | multiple select | `false` |
| sureTitle | String | `isMultiSelect = true`, The sure button's title | `Sure` |
| multiSelectedHandler | Closure | Call back when `sure` button touched, applied when `isMultiSelect  = true` | `Optional` |
| backgroundColor | UIColor | The cell's backgroundColor | `.white` |
| selectedBackgroundColor | UIColor | The cell's backgroundColor when selected | `Optional` |
| selectedImage | UIImage | Add an image to cell when selected, applied when `isMultiSelect = true` | `Optional` |
| layout | UICollectionViewFlowLayout | The layout for cells | `Optional` |

Show datas.

```swift
eView.showDatas(datas, with: config) { idx in print("Current select: \(idx)")}
```

### I have multiple EViews, what should i do?

Don't worry! The class named [`EViewGroup`](#eviewgroup) might be helpful to you.

*(we are sure that you have some information about EView.)*

Firstly, Suppose we have some EView instances named `eView1`, `eView2`, `eView3`...

Then, create an instance of `EViewGroup`

```swift
let eGroup = EViewGroup.init(layout: .center, mode: .one, with: eView1, eView2, eView3)
eGroup.formed()
```
ended!?, Indeed, if you don't want to know more.

goes on, How to initialize EViewGroup and what parameters are passed in?

```swift
/// Initializing EVeiwGroup requires three parameters, but two of them can use the default parameters.
/// First. use two default params to init
let eGroup = EViewGroup.init(with: eView1, eView2, eView3)

/// Second. Use one default params to init
let eGroup = EViewGroup.init(layout: .center, with: eView1, eView2, eView3)
// or
let eGroup = EViewGroup.init(mode: .one, with: eView1, eView2, eView3)

/// Third. Use nothing default params to init
let eGroup = EViewGroup.init(layout: .center, mode: .one, with: eView1, eView2, eView3) 
```
What does these parameters mean?

| name | type | description |
| :--: | :--: | --------- |
| layout | [EViewGroupLayout](https://github.com/yutingLei/Expander/blob/626d6a73fbfd464f131a10ea6f45b8dc6248418c/Expander/EViewGroup.swift#L24) | Views arrangement, all the arrangement will be calculated according to the order of the array. defautl is '.start' |
| mode | [EViewGroupExpande](https://github.com/yutingLei/Expander/blob/626d6a73fbfd464f131a10ea6f45b8dc6248418c/Expander/EViewGroup.swift#L40) | Whether EViews can exist simultaneously when expanded |

Is there any property that can be introduced?

| name | type | description |
| :--: | :--: | --------- |
| interItemSpacing | CGFloat | Spacing between each view. only supports layouts of `.start`, `.end`, and `.center` |


## Demo

**[Simple EView and Configurations](https://github.com/yutingLei/Expander/blob/master/simple-eview-demo.md)**

**[EView with datas](https://github.com/yutingLei/Expander/blob/master/simple-eview-datas-demo.md)**

**[EViewGroup](https://github.com/yutingLei/Expander/blob/master/group-eview-demo.md)**


## TODO
- [x] Basic functions
- [ ] Add dynamic behaviors?
- [x] Multiple EViews `EViewGroup`

