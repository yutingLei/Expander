## Expander

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![Platform](https://img.shields.io/badge/platform-iOS-4BC51D.svg) ![Swift](https://img.shields.io/badge/Swift-4.2-4BC51D.svg)

[English](https://github.com/yutingLei/Expander/blob/master/README-En.md)

## 导入

### 使用Carthage导入
若未安装[Carthage](https://github.com/Carthage/Carthage)，使用下面方法安装：

```
$ brew update
$ brew install carthage
```

将一下内容添加到`Cartfile`文件中.

```
github "yutingLei/Expander" "master"
```

在命令行中，`cd`到工程根目录，运行`carthage update`命令，将编译好的`Expander.framework`添加到Xcode项目中去。

### 手动导入
直接复制`Expander`文件夹到项目中去，并添加到工程中即可.



## 使用

首先, 在需要的文件中导入`Expaner`.

```swift
import Expander
```

### 初始化

使用类方法初始化`EView`实例:

```swift
/// 参数view是EView的父视图
/// 无需担心交叉强应用，该视图在EView中是weak类型
let eView = EView.serialization(in: view)
view.addSubview(eView)
```

### 配置`EView`
*使用默认的配置可以跳过配置.*

实例化配置. *注意：`EViewConfig`是`struct`类型*.

```swift
var config = EViewConfig()
```

可设置的属性:

| 属性名 | 类型 | 描述 | 默认值 |
| :-----------: | :--: | :--------- | :-----------: |
| size | CGSize | EView的原始大小 | `80x80` |
| expandSize | CGSize | EView扩展后的大小，其中宽度小于0时，使用默认宽度；高度同理 | `Optional` |
| expandCornerRadius | CGFloat | EView展开后的边角弧度 | `10` |
| distanceToTop | CGFloat | EView到父视图顶部的距离 | `Optional` |
| padding | EViewPadding | EView相对父视图的边缘填充 | `EViewPadding(0, 8)` |
| expandType | [EViewExpandType](https://github.com/yutingLei/Expander/blob/d9f57eb52fb4fe9f019bc07290fc62dd89c1a1b3/Expander/EViewConfig.swift#L18) | EView展开时的模式 | `.center` |
| located | [EViewLocated](https://github.com/yutingLei/Expander/blob/d9f57eb52fb4fe9f019bc07290fc62dd89c1a1b3/Expander/EViewConfig.swift#L25) | EView位于父视图的左/右边  | `.left` |
| stateFlag | Touple | 控制按钮展开/收拢状态的标题 | `("Expand", "Fold")` |
| isViscosity | Bool | 是否具有粘性，为`true`时，可以移动EView，但在手指松开后会回到原来的位置 | `Optional` |

配置完成后，必须调用一次`applyConfig`函数.

```swift
eView.applyConfig(config)
```

## 扩展

### 如果我想自己控制EView的展开和收拢怎么办?

下面两个方法用于展开和收拢

```swift
/// 展开动作
/// rect: 如果设置了rect，那么展开后的frame = rect，仅限本次有效
public func expand(to rect: CGRect? = nil)
/// 收拢动作
/// rect: 如果设置了rect，那么收拢后的frame = rect，仅限本次有效
public func fold(to rect: CGRect? = nil)
```

### 为EView添加视图

当创建`EView`后，可以获取一个`contentView`的属性，此时可以向里面添加任意视图。

### 有快速的方法显示数据吗?

当然，可以使用默认的显示方式，而这仅需一点代码。  
首先，假设有以下一个数组:

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

初始化cell配置 `EViewCellConfig`:

```swift
/// 初始化配置
/// 注意：传入的keys是取字典值的key,第一个必须是标题的key，第二个必须是图片的key
let cellConfig = EViewCellConfig(keys: ["title", "image"])
```

设置一些其它属性. *使用默认的可以跳过设置。*

| 属性名 | 类型 | 描述 | 默认值 |
| :-----------: | :--: | :--------- | :-----------: |
| mode | [EViewCellMode](https://github.com/yutingLei/Expander/blob/d9f57eb52fb4fe9f019bc07290fc62dd89c1a1b3/Expander/EViewConfig.swift#L91) | cell的显示模式，`.default`表示上面是标题，下面是图片; `.classic`与之相反 | `.default` |
| isMultiSelect | Bool | 是否多选 | `false` |
| sureTitle | String | 确认按钮的标题，仅在`isMultiSelect = true`时有效 | `Sure` |
| multiSelectedHandler | Closure | 当`isMultiSelect  = true`时，点击确认按钮的回调函数 | `Optional` |
| backgroundColor | UIColor | 每个cell的背景色 | `.white` |
| selectedBackgroundColor | UIColor | cell在选中状态下的背景色，需`isMultiSelect = false` | `Optional` |
| selectedImage | UIImage | 选中状态的图片，仅`isMultiSelect = true`有效 | `Optional` |
| layout | UICollectionViewFlowLayout | cell的排列方式 | `Optional` |

调用函数来显示数据:

```swift
eView.showDatas(datas, with: config) { idx in print("Current select: \(idx)")}
```

### 我想控制多个EView,该怎么破?

别担心！你可以使用[`EViewGroup`](#eviewgroup)这个类.

假设声明了多个`EView`的实例： `eView1`, `eView2`, `eView3`...

然后我们创建`EViewGroup`管理组

```swift
let eGroup = EViewGroup.init(layout: .center, mode: .one, with: eView1, eView2, eView3)
eGroup.formed()
```
就这样!?, 如果简单使用，两行代码就可以为解决问题。

当然，还有可配置参数（使配置参数生效必须在调用`formed`函数之前）：

| 属性 | 类型 | 描述 |
| :--: | :--: | --------- |
| layout | [EViewGroupLayout](https://github.com/yutingLei/Expander/blob/626d6a73fbfd464f131a10ea6f45b8dc6248418c/Expander/EViewGroup.swift#L24) | 被管理视图的排列方式 |
| mode | [EViewGroupExpande](https://github.com/yutingLei/Expander/blob/626d6a73fbfd464f131a10ea6f45b8dc6248418c/Expander/EViewGroup.swift#L40) | 被管理视图同时能够展开个数 |
| interItemSpacing | CGFloat | 相邻两个EView视图间隔. 只支持`layout = ` `.start`/`.end`/`.center` |


## 案例

**[简单的EView使用方法和配置](https://github.com/yutingLei/Expander/blob/master/simple-eview-demo.md)**

**[使用EView显示数据](https://github.com/yutingLei/Expander/blob/master/simple-eview-datas-demo.md)**

**[EViewGroup的使用方法](https://github.com/yutingLei/Expander/blob/master/group-eview-demo.md)**


## TODO
- [x] Basic functions
- [ ] Add dynamic behaviors?
- [x] Multiple EViews `EViewGroup`

