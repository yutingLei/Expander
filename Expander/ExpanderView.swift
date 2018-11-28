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

    /// 控制展开或收拢的标志，可以使字符串，也可以是图片
    public var controlFlag: Any! {
        willSet {
            if newValue is String {
                _tapButton.setTitle(newValue as? String, for: .normal)
            }
            if newValue is UIImage {
                _tapButton.setImage(newValue as? UIImage, for: .normal)
            }
        }
    }

    /// 类容视图
    public private(set) lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: bounds.width / 2, y: bounds.height / 2, width: 1, height: 1))
        view.backgroundColor = .white
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
        expanderView._tapButton.backgroundColor = UIColor.orange
        expanderView._tapButton.setTitle("展开", for: .normal)
        expanderView._tapButton.addTarget(expanderView, action: #selector(tapAction(_:)), for: .touchUpInside)
        expanderView.addSubview(expanderView._tapButton)
        return expanderView
    }
}

public extension EVExpanderView {

    /// 点击方法触发
    @objc private func tapAction(_ ges: UITapGestureRecognizer) {
        _isExpanded ? fold() : expand()
        _isExpanded = !_isExpanded
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
            let x = self.layout.location == .left ? self.frame.minX : self.layout.padding.left
            var y = self.frame.minY

            /// 根据不同类型，计算原点
            switch self.expandType {
            case .up:
                y = self.frame.maxY - self._expandSize.height
                if y < 0 {
                    y = 0
                }
            case .down:
                if self._sView.bounds.maxY < self.frame.minY + self._expandSize.height {
                    y = self._sView.bounds.maxY - self._expandSize.height
                }
            default:
                y = self.frame.midY - self.layout.expandSize!.height / 2
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
            self.contentView.frame = CGRect(x: 4, y: 30, width: self.bounds.width - 8, height: self.bounds.height - 34)
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
            let x = self.layout.location == .left ? 0 : self.frame.maxX
            self.contentView.frame = CGRect(x: x, y: self.bounds.midY, width: 1, height: 1)
        }) { _ in self._isExpanded = false }
    }
}


