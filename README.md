## Expander

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![Platform](https://img.shields.io/badge/platform-iOS-4BC51D.svg) ![Swift](https://img.shields.io/badge/Swift-4.0-4BC51D.svg)


## Installation

使用[`Carthage`](https://github.com/Carthage/Carthage)导入，在项目根目录下创建一个名为`Cartfile`的文件，将下面的类容赋值进去：

```
github "yutingLei/Expander" "master"
```

接下来在终端运行下面命令:

```sh
carthage update --platform iOS
```

## Easy to use

使用很少一点代码即可创建`Expander`.

* 使用`serialization(in:)`类方法创建[ExpanderView](#evexpanderview)实例  
	`注意`: 创建`Expander`实例不能用任何`init`方法

	```swift
	// 此处view是Expander的父视图
	let expander = EVExpanderView.serialization(in: view)
	view.addSubview(expander)
	```
到此，你可以编译和运行了，不妨看看效果再继续下面的类容^_^

* 配置`Expander`
	- [EVExpanderViewLayout](#evexpanderviewlayout): 该类用于配置`Expander`各项参数,也可以使用默认参数，忽略该部分。
	
		```swift
		/// 声明配置类
		var layout = EVExpanderViewLayout()
		/// Expander的初始大小, 默认： 80x80
		layout.size = CGSize.init(width: 100, height: 100)
		/// Expander扩展后的大小，默认：宽=父视图宽-左右填充，高=120
		layout.expandSize = CGSize.init(width: 200, height: 200)
		/// 决定Expander的y轴值，不设置默认Expander的midX=superview.midX
		layout.distanceToTop = 200
		/// 决定Expander位于父视图的左边还是右边，默认左边
		layout.location = .right
		/// Expander相对父视图的填充
		/// 以下面这个为例：若位于父视图左边，则表示Expander的左边到父视图左边的距离为20
		///					 若位于父视图右边，则表示Expander的右边到父视图的右边的距离为20
		///	 当展开状态是，表示Expander的左右分别距离父视图的距离
		layout.padding = EVPadding(left: 20, right: 20)
		/// 应用配置
		expanderView.applyLayout(layout)
		```
	
		`注意`: 任何配置都必须调用`applyLayout`方法才能使其生效。
	
	- expandType: 决定展开方式
		
		```swift
		/// 默认展开方式： .center
		/// .up: 底部y值不变，向上展开，超过父视图顶部则会设minY=padding.top
		/// .center: 中心xy不变，向两边展开
		/// .bottom: 顶部y不变，向下展开，超过父视图底部则会设maxY=padding.bottom
		expanderView.expandType = .up // .center | .down
		```

* 添加内容	
	
	- `applyImageTitles`: 添加内容（上面图片，下面标题）
	- `applyTitleImages`: 添加内容（上面标题，下面图片）
	- [EVExpanderViewCellConfiguration](#evexpanderviewcellconfiguration): 内容item的配置类
	
	第一步：声明一个测试数组
	
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
	第二步：创建配置，可以使用默认配置，直接跳过该步骤
	
	```swift
	/// 创建一个item（或者叫cell）配置
	let config = EVExpanderViewCellConfiguration()
	/// 两个cell之间的距离，默认4
	config.spacing = EVPadding.init(p: 4)
	/// 两个cell之间的颜色，默认rgb(240, 240, 240)
	config.spacingColor = .orange
	/// cell的背景色，默认白色
	config.backgroundColor = .green
	```
	
	第三步：设置取值的key值
	
	```swift
	/// 注意，此处必须先标题后图片的key
	let getValueKeys = ["title", "image"]
	```
	
	第四部：添加内容，一下两种方式任选其一
	
	```swift
	/// 1. 使用自定义配置的方式
	expanderView.applyImageTitles(datas, cellConfiguration: config, withKeys: getValueKeys)
	
	/// 2. 使用默认配置，可以忽略cellConfiguration这个参数
	expanderView.applyImageTitles(datas, withKeys: getValueKeys)
	```

## Classes

### EVExpanderView

* Properties

	| name | class/type | description |
	| :---: | :---:| :---: |
	| layout | [EVExpanderViewLayout](#evexpanderviewlayout) | Expander布局对象 |
	| contentView | UIView | Expander的内容承载视图 |
	| expandType | Enum | Expander的展开方式 |
	| controlFlat | Touple | 显示展开和收拢的标志，默认("展开", "收拢")|

* Functions

	```swift
	/// 类方法实例化一个ExpanderView
   ///
   /// - Parameter superView: 该视图的父视图
   /// - Returns: 一个ExpanderView对象
	public class func serialization(in superView: UIView) -> EVExpanderView
	
	/// 应用布局，注意：每次修改布局内的属性后，都要调用一次applyLayout
    ///
    /// - Parameter layout: 视图自身布局对象
	public func applyLayout(_ layout: EVExpanderViewLayout)
	
	/// 显示模板视图,图片-标题
    ///
    /// - Parameters:
    ///   - datas: 数据数组
    ///   - cellConfiguration: 模板cell视图配置，忽略该参数则使用默认配置
    ///   - keys: 取的标题和图片名称的key值
    public func applyImageTitles(_ datas: [[String: Any]],
                                 cellConfiguration: EVExpanderViewCellConfiguration,
                                 withKeys keys: [String])
                                 
	/// 显示模板视图,标题-图片
    ///
    /// - Parameters:
    ///   - datas: 数据数组
    ///   - cellConfiguration: 模板cell视图配置，忽略该参数则使用默认配置
    ///   - keys: 取的标题和图片名称的key值
	public func applyTitleImages(_ datas: [[String: Any]],
                                 cellConfiguration: EVExpanderViewCellConfiguration,
                                 withKeys keys: [String])
	
	/// 展开，调用该函数展开视图
	public func expand()  
	
	/// 收拢，调用该函数收拢视图
	public func fold()  
	```
	
	

### EVExpanderViewLayout

* Properties
	
	| name | class/type | description |
	| :---: | :---:| :---: |
	| size | CGSize | ExpanderView的初始大小 |
	| expandSize | CGSize? | ExpanderView展开后的大小,不设置则使用默认值 |
	| padding | [EVPadding](#evpadding) | ExpanderView相对父视图的填充 |
	| location | Enum | ExpanderView在父视图的左边或右边 |
	| distanceToTop | CGFloat? | 视图到父视图顶部的距离，不设置默认在父视图中间 |
	

### EVExpanderViewCellConfiguration

EVExpanderViewCellConfiguration继承至UICollectionViewFlowLayout

* Properties
	
	| name | class/type | description |
	| :---: | :---:| :---: |
	| spacing | [EVPadding](#evpadding) | 确定cell与cell之间的间隔 |
	| spacingColor | UIColor | cell父视图的背景色 |
	| backgroundColor | UIColor | cell的背景色 |

### EVPadding

* Properties

	| name | class/type | description |
	| :---: | :---:| :---: |
	| top | CGFloat | 顶部填充 |
	| left | CGFloat | 左边填充 |
	| bottom | CGFloat | 底部填充 |
	| right | CGFloat | 右边填充 |
	
* Functions

	```swift
	/// 初始化填充
	/// 填充赋值顺序：上-左-下-右
	/// 若p.count = 1: 上下左右=p[0]
	/// 若p.count = 2: 上下=p[0], 左右=p[1]
	/// 若p.count = 3: 上=p[0], 左右=p[1], 下=p[2]
	/// 若p.count = 4: 按顺序赋值
	/// 若p.count > 4: 忽略所有值
	public init(p: CGFloat...)
	```

## TODO
- [x] 实现基础功能 
- [ ] 添加重力感应  
- [ ] flex创建方式  

