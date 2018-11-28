//
//  ExpanderView.swift
//  Expander
//
//  Created by yutingLei on 2018/11/27.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit

public class EVExpanderView: UIView {
    /// 视图位于父视图左右
    public enum EVLayout {
        case left
        case right
    }

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
    private var _preExpandOrigin: CGPoint?

    //MARK: - Publics
    /// 相对父视图左右边距。若设置layout，则必须在layout之前
    public var padding = EVPadding(left: 8, right: 8)

    /// 相对于父视图的位置
    public var layout: EVLayout = .left {
        willSet {
            if newValue == .right {
                let w = _sView.bounds.width - size.width - padding.right
                frame.origin = CGPoint(x: w, y: frame.minY)
            } else {
                frame.origin = CGPoint(x: padding.left, y: frame.minY)
            }
        }
    }

    /// 展开方式
    public var expandType: EVExpandType = .center

    /// 视图大小
    public var size = CGSize(width: 80, height: 80) {
        willSet {
            frame.size = newValue
        }
    }

    /// 视图展开大小，默认宽度为父视图宽度减去padding左右宽度，高度为120
    public lazy var expandedSize: CGSize = {
        return CGSize(width: _sView.bounds.width - padding.left - padding.right, height: 120)
    }()

    /// 标题
    public lazy var titleLabel: UILabel = {
        let label = UILabel(frame: bounds)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        _tapButton.addSubview(label)
        return label
    }()

    /// 类容视图
    public lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 40, y: 40, width: 1, height: 1))
        view.backgroundColor = .white
        addSubview(view)
        bringSubviewToFront(_tapButton)
        return view
    }()

    /// 序列化视图
    public class func serialization(in superView: UIView) -> EVExpanderView {
        let expanderView = EVExpanderView()
        expanderView.clipsToBounds = true
        expanderView._sView = superView
        expanderView.frame.origin = CGPoint(x: 4, y: superView.bounds.height / 2 - 40)
        expanderView.frame.size = CGSize(width: 80, height: 80)
        expanderView.layer.cornerRadius = 40
        expanderView.backgroundColor = UIColor.rgb(0, 191, 255)

        /// 添加手势视图
        expanderView._tapButton = UIButton(frame: expanderView.bounds)
        expanderView._tapButton.backgroundColor = UIColor.orange
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
        UIView.animate(withDuration: 0.5) {[unowned self] in

            /// 设置圆角
            self.layer.cornerRadius = 10

            /// 获取xy值
            let x = self.padding.left
            var y: CGFloat = self.frame.minY

            /// 根据不同类型，计算原点
            switch self.expandType {
            case .up:
                y = self.frame.maxY - self.expandedSize.height
                if y < 0 {
                    y = 0
                }
            case .down:
                if self._sView.bounds.maxY < self.frame.minY + self.expandedSize.height {
                    y = self._sView.bounds.maxY - self.expandedSize.height
                }
            default:
                y = self.frame.midY - self.expandedSize.height / 2
                break
            }

            /// 设置原点和大小
            self.frame.origin = CGPoint(x: x, y: y)
            self.frame.size = self.expandedSize

            /// 设置可点击按钮的frame
            if self.layout == .left {
                self._tapButton.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
            } else {
                self._tapButton.frame = CGRect(x: self.frame.width - 80, y: 0, width: 80, height: 30)
            }

            /// 设置标题的frame
            self.titleLabel.frame = self._tapButton.bounds

            /// 显示contentView
            self.contentView.frame = CGRect(x: 4, y: 30, width: self.bounds.width - 8, height: self.bounds.height - 34)
        }
    }

    /// 收拢
    public func fold() {
        guard _isExpanded else { print("Has already folded"); return }
        UIView.animate(withDuration: 0.5) {[unowned self] in
            self.layer.cornerRadius = self.size.width / 2

            /// 恢复大小
            self.frame.origin = self._preExpandOrigin ?? CGPoint.zero
            self.frame.size = self.size

            /// 设置标题和可点击按钮
            self._tapButton.frame = self.bounds
            self.titleLabel.frame = self._tapButton.bounds

            /// 隐藏contentView
            let x = self.layout == .left ? 0 : self.frame.maxX
            self.contentView.frame = CGRect(x: x, y: self.bounds.midY, width: 1, height: 1)
        }
    }
}


