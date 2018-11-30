//
//  ExpanderView.swift
//  Expander
//
//  Created by yutingLei on 2018/11/27.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit

public class EVExpanderView: UIView {

    /// 展开方式，左右展开方式都以当前坐标为基准
    ///             layout = .left      layout = .right
    /// .up：        向右上展开           向左上展开
    /// .down：      向右下展开           向左下展开
    /// .center：    从中间展开           从中间展开
    public enum EVExpandType {
        case up
        case down
        case center
    }

    //MARK: - Privates
    /// 父视图
    private weak var _sView: UIView!

    /// 可点击视图，控制折叠和展开
    private var _tapButton: UIButton!

    /// 是否已经展开视图
    private var _isExpanded = false
    private var _expandSize: CGSize!
    private var _preExpandOrigin: CGPoint?

    //MARK: - Publics
    /// 视图布局对象
    public private(set) var layout: EVExpanderViewLayout! {
        willSet {
            guard !_isExpanded  else { print("展开状态下不能设置layout！"); return }
            /// 设置大小和圆角
            frame.size = newValue.size
            layer.cornerRadius = min(newValue.size.width, newValue.size.height) / 2

            /// 设置xy值
            let distance = newValue.distanceToTop ?? (_sView.bounds.height - newValue.size.height) / 2
            if newValue.location == .left {
                frame.origin = CGPoint(x: newValue.padding.left, y: distance)
            } else {
                let right = _sView.bounds.width - newValue.padding.right - newValue.size.width
                frame.origin = CGPoint(x: right, y: distance)
            }

            /// 设置扩展大小
            let padding = newValue.padding.left + newValue.padding.right
            _expandSize = newValue.expandSize ?? CGSize(width: _sView.bounds.width - padding, height: 120)
        }
    }

    /// 展开方式
    public var expandType: EVExpandType = .center

    /// 设置视图展开收拢的控制标志或图片
    public var controlFlag: (origin: Any, expanded: Any)! {
        willSet {
            if let text = newValue.expanded as? String {
                _tapButton.setTitle(text, for: .selected)
            } else if let image = newValue.expanded as? UIImage {
                _tapButton.setImage(image, for: .selected)
            }
            if let text = newValue.origin as? String {
                _tapButton.setTitle(text, for: .normal)
            } else if let image = newValue.origin as? UIImage {
                _tapButton.setImage(image, for: .normal)
            }
        }
    }

    /// 类容视图
    public private(set) lazy var contentView: UIView = {
        let w = _expandSize.width
        let h = _expandSize.height
        let view = UIView(frame: CGRect(x: 4, y: 30, width: w - 8, height: h - 34))
        view.backgroundColor = .white
        view.alpha = 0
        addSubview(view)
        bringSubviewToFront(_tapButton)
        return view
    }()

    /// 应用布局，注意：每次修改布局内的属性后，都要调用一次applyLayout
    ///
    /// - Parameter layout: 视图自身布局对象
    public func applyLayout(_ layout: EVExpanderViewLayout) {
        self.layout = layout
        if !_isExpanded {
            _tapButton.frame = bounds
        }
    }

    /// ExpanderView的初始化方式
    ///
    /// - Parameter superView: 该视图的父视图
    /// - Returns: 一个ExpanderView对象
    public class func serialization(in superView: UIView) -> EVExpanderView {
        let expanderView = EVExpanderView()
        expanderView.clipsToBounds = true
        expanderView._sView = superView

        /// 视图默认布局
        expanderView.layout = EVExpanderViewLayout()

        /// 配置其它属性
        expanderView.backgroundColor = UIColor.rgb(0, 191, 255)

        /// 添加手势视图
        expanderView._tapButton = UIButton(frame: expanderView.bounds)
        expanderView._tapButton.addTarget(expanderView, action: #selector(tapAction(_:)), for: .touchUpInside)
        expanderView.addSubview(expanderView._tapButton)

        /// 设置控制标志
        expanderView.controlFlag = ("展开", "收拢")
        return expanderView
    }
}

public extension EVExpanderView {

    /// 点击方法触发
    @objc private func tapAction(_ ges: UITapGestureRecognizer) {
        _isExpanded ? fold() : expand()
        _isExpanded = !_isExpanded
        _tapButton.isSelected = _isExpanded
    }

    /// 展开
    public func expand() {
        guard !_isExpanded else { print("Has already expanded!"); return }
        /// 保存展开前的原点
        _preExpandOrigin = frame.origin

        /// 展开动画
        UIView.animate(withDuration: 0.5, animations: {[unowned self] in

            /// 设置圆角
            self.layer.cornerRadius = 10

            /// 获取xy值
            let x = self.layout.location == .left ? self.frame.minX : (self.frame.maxX - self._expandSize.width)
            var y = self.frame.minY

            /// 根据不同类型，计算原点
            switch self.expandType {
            case .up:
                y = self.frame.maxY - self._expandSize.height
                if y < 0 {
                    y = self.layout.padding.top
                }
            case .down:
                if self._sView.bounds.maxY < self.frame.minY + self._expandSize.height {
                    y = self._sView.bounds.maxY - self._expandSize.height - self.layout.padding.bottom
                }
            default:
                y = self.frame.midY - self._expandSize!.height / 2
                break
            }

            /// 设置原点和大小
            self.frame.origin = CGPoint(x: x, y: y)
            self.frame.size = self._expandSize

            /// 设置可点击按钮的frame
            if self.layout.location == .left {
                self._tapButton.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
            } else {
                self._tapButton.frame = CGRect(x: self.frame.width - 80, y: 0, width: 80, height: 30)
            }

            /// 显示contentView
            self.contentView.alpha = 1
        }) {_ in self._isExpanded = true }
    }

    /// 收拢
    public func fold() {
        guard _isExpanded else { print("Has already folded"); return }
        UIView.animate(withDuration: 0.5, animations: {
            self.layer.cornerRadius = self.layout.size.width / 2

            /// 恢复大小
            self.frame.origin = self._preExpandOrigin ?? CGPoint.zero
            self.frame.size = self.layout.size

            /// 设置标题和可点击按钮
            self._tapButton.frame = self.bounds

            /// 隐藏contentView
            self.contentView.alpha = 0
        }) { _ in self._isExpanded = false }
    }
}

/// 显示Cell扩展
extension EVExpanderView: UICollectionViewDataSource, UICollectionViewDelegate {

    /// 定义回调closure
    public typealias EVSelectedItemHandler = (Int) -> Void

    /// 保存数据
    internal struct EVExpanderViewCellHolder {
        static var model = "title-image"
        static var getValueKeys: [String]!
        static var dataSource: [[String: Any]]!
        static var collectionView: UICollectionView?
        static var cellConfiguration: EVExpanderViewCellConfiguration!
        static var selectedItemHandler: EVSelectedItemHandler?
        static var currentSelectedIndex: Int?
    }

    /// 显示模板视图,图片-标题
    ///
    /// - Parameters:
    ///   - datas: 数据数组
    ///   - cellConfiguration: 模板cell视图配置
    ///   - keys: 取的标题和图片名称的key值
    ///   - block: 点击cell回调函数，index为点击cell坐在数组中的下标
    public func applyImageTitles(_ datas: [[String: Any]],
                                 cellConfiguration: EVExpanderViewCellConfiguration = EVExpanderViewCellConfiguration(),
                                 withKeys keys: [String],
                                 didSelectItem handler: EVSelectedItemHandler? = nil)
    {
        /// 是否有数据
        guard datas.count != 0 else { return }
        EVExpanderViewCellHolder.model = "image-title"
        EVExpanderViewCellHolder.dataSource = datas
        EVExpanderViewCellHolder.getValueKeys = keys
        EVExpanderViewCellHolder.selectedItemHandler = handler
        applyDatas(with: cellConfiguration)
    }

    /// 显示模板视图,标题-图片
    ///
    /// - Parameters:
    ///   - datas: 数据数组
    ///   - cellConfiguration: 模板cell视图配置
    ///   - keys: 取的标题和图片名称的key值
    ///   - block: 点击cell回调函数，index为点击cell坐在数组中的下标
    public func applyTitleImages(_ datas: [[String: Any]],
                                 cellConfiguration: EVExpanderViewCellConfiguration = EVExpanderViewCellConfiguration(),
                                 withKeys keys: [String],
                                 didSelectItem handler: EVSelectedItemHandler? = nil)
    {
        /// 是否有数据
        guard datas.count != 0 else { return }
        EVExpanderViewCellHolder.model = "title-image"
        EVExpanderViewCellHolder.dataSource = datas
        EVExpanderViewCellHolder.getValueKeys = keys
        EVExpanderViewCellHolder.selectedItemHandler = handler
        applyDatas(with: cellConfiguration)
    }

    /// 应用cell的配置
    ///
    /// - Parameter config: cell配置对象
    internal func applyDatas(with config: EVExpanderViewCellConfiguration) {
        EVExpanderViewCellHolder.cellConfiguration = config

        /// 初始化collectionView
        if EVExpanderViewCellHolder.collectionView == nil {
            let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: config)
            collectionView.register(EVExpanderViewCell.self, forCellWithReuseIdentifier: "com.expanderview.content.cell")
            collectionView.backgroundColor = config.spacingColor
            contentView.addSubview(collectionView)

            /// 保存配置
            EVExpanderViewCellHolder.collectionView = collectionView

            /// 其它设置
            collectionView.dataSource = self
            collectionView.delegate = self
        } else {
            EVExpanderViewCellHolder.collectionView?.collectionViewLayout = config
            EVExpanderViewCellHolder.collectionView?.reloadData()
        }
    }

    //MARK: - Collection view datasource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EVExpanderViewCellHolder.dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.expanderview.content.cell",
                                                      for: indexPath) as! EVExpanderViewCell
        /// 配置背景色
        let config = EVExpanderViewCellHolder.cellConfiguration
        if let selectedColor = config?.selectedBackgroundColor, indexPath.row == EVExpanderViewCellHolder.currentSelectedIndex {
            cell.contentView.backgroundColor = selectedColor
        } else {
            cell.contentView.backgroundColor = EVExpanderViewCellHolder.cellConfiguration.backgroundColor
        }

        /// 创建标题
        if cell.titleLabel == nil {
            cell.titleLabel = UILabel(frame: cell.contentView.bounds)
            cell.titleLabel?.frame.size.height = cell.contentView.bounds.height * 0.25
            cell.titleLabel?.textColor = .black
            cell.titleLabel?.textAlignment = .center
            cell.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell.contentView.addSubview(cell.titleLabel!)
            if EVExpanderViewCellHolder.model == "image-title" {
                cell.titleLabel?.frame.origin.y = cell.contentView.bounds.height * 0.75
            }
        }

        /// 创建图片
        if cell.imageView == nil {
            cell.imageView = UIImageView.init(frame: cell.contentView.bounds)
            cell.imageView?.frame.origin.y = cell.contentView.bounds.height * 0.25
            cell.imageView?.frame.size.height = cell.contentView.bounds.height * 0.75
            cell.imageView?.contentMode = .scaleAspectFit
            cell.contentView.addSubview(cell.imageView!)
            if EVExpanderViewCellHolder.model == "image-title" {
                cell.imageView?.frame.origin.y = 0
            }
        }

        /// 赋值
        let data = EVExpanderViewCellHolder.dataSource[indexPath.row]
        let title = data[EVExpanderViewCellHolder.getValueKeys[0]] as? String
        cell.titleLabel?.text = title
        cell.imageView?.image = EVExpanderHelp.generateImage(by: data[EVExpanderViewCellHolder.getValueKeys[1]] as? String)

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// 如果设置了选中a颜色，则改变选中的cell的背景色
        if let _ = EVExpanderViewCellHolder.cellConfiguration.selectedBackgroundColor {
            EVExpanderViewCellHolder.currentSelectedIndex = indexPath.row
            collectionView.reloadData()
        }
        /// 回调触发
        guard let handler = EVExpanderViewCellHolder.selectedItemHandler else { return }
        handler(indexPath.row)
    }
}

/// 自定义cell
private class EVExpanderViewCell: UICollectionViewCell {

    /// 标题
    fileprivate var titleLabel: UILabel?
    /// 图片
    fileprivate var imageView: UIImageView?

    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// 初始化出错
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
