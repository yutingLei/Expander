//
//  EViewGroup.swift
//  Expander
//
//  Created by yutingLei on 2018/12/6.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit

public class EViewGroup {

    /// 子视图排列方式，注意：除viewSelf之外，所有子视图的distanceToTop都将被忽略
    ///
    /// - spaceBetween: 所有子视图排列在父视图上下两端
    /// - spaceAround: 所有子视图按等分排列在父视图中
    /// - center: 所有子视图从父视图中间向上下两边排列
    /// - start: 所有子视图从父视图顶部开始排列
    /// - end: 所有子视图从父视图底部开始排列
    /// - viewSelf: Group不对子视图排列做任何操作
    public enum EViewGroupLayout {
        case spaceBetween
        case spaceAround
        case center
        case start
        case end
        case viewSelf
    }

    /// EView管理组对子视图展开管理
    ///
    /// - onlyOne: 同时只能存在一个子视图展开
    /// - more: 同时可以存在多个子视图展开
    /// - clever: 智能展开方式，在下一个子视图展开时会计算展开后是否越过父视图边界。越过则会收拢最开始展开的视图，然后展开当前子视图。
    public enum EViewGroupExpande {
        case one
        case more
        case clever
    }

    //MARK: Private vars
    private var _isFormed = false
    private lazy var _expandedViewsIndex: [Int] = {
        return [Int]()
    }()

    //MARK: Public vars
    public private(set) var layout: EViewGroupLayout!
    public private(set) var mode: EViewGroupExpande!
    public private(set) var views: [EView]!
    public var interItemSpacing: CGFloat = 0

    /// 初始化EView管理组
    ///
    /// - Parameters:
    ///   - layout: 子视图排列方式，所有排列方式会按照数组顺序来计算. defautl is '.start'
    ///   - mode: 子视图在展开时是否能够同时存在
    ///   - views: 子视图数组
    public required init(layout: EViewGroupLayout = .start, mode: EViewGroupExpande = .clever, with views: EView...) {
        assert(views.count != 0 && views.count > 1, "The count of views must be greater than 1.")
        assert(isSameParentView(with: views), "All of the views are must have the same parent view.")

        self.layout = layout
        self.mode = mode
        self.views = views
    }

    public func formed() {
        guard !_isFormed else {
            print("The 'formed' function can only be called once")
            return
        }
        _isFormed = true

        /// 根据排列模式，重新组织视图在父视图中的位置
        relayoutViews()

        /// 将视图添加到父视图上并重置触发target
        for view in views {
            view._parentView.addSubview(view)
            view.controlButton.removeTarget(view, action: nil, for: .touchUpInside)
            view.controlButton.addTarget(self, action: #selector(viewsControlButtonAction(_:)), for: .touchUpInside)
        }
    }
}

extension EViewGroup {

    /// 判断视图的父视图是否是同一个视图
    func isSameParentView(with views: [EView]) -> Bool {
        var isSame = true
        var iterator = views.makeIterator()
        _ = iterator.next()
        for i in 0..<views.count - 1 {
            if views[i]._parentView != iterator.next()?._parentView {
                isSame = false
            }
        }
        return isSame
    }

    /// 重新计算子视图位置
    func relayoutViews() {

        /// 如果排列模式是viewSelf，直接返回
        guard layout != .viewSelf else { return }

        /// 声明常规参数
        var startY: CGFloat = 0
        var viewsHeight: CGFloat = 0
        _ = views.map(){ view in viewsHeight += view.height }

        /// 根据排列方式分别计算视图位置
        switch layout! {
        case .end:
            var maxY: CGFloat = views[0]._parentView.height
            for i in (0..<views.count).reversed() {
                var config = views[i]._config
                config.distanceToTop = maxY - views[i].height
                views[i].applyConfig(config)
                maxY -= (views[i].height + interItemSpacing)
            }
        case .spaceBetween:
            let itemSpacing = (views[0]._parentView.height - viewsHeight) / CGFloat(views.count - 1)
            for i in 0..<views.count {
                var config = views[i]._config
                config.distanceToTop = startY
                views[i].applyConfig(config)
                startY += (views[i].height + itemSpacing)
            }
        case .spaceAround:
            let itemSpacing = (views[0]._parentView.height - viewsHeight) / CGFloat(views.count + 1)
            startY += itemSpacing
            for i in 0..<views.count {
                var config = views[i]._config
                config.distanceToTop = startY
                views[i].applyConfig(config)
                startY += (views[i].height + itemSpacing)
            }
        default:
            var startY: CGFloat = 0
            if layout == .center {
                startY = (views[0]._parentView.height - viewsHeight - CGFloat(views.count - 1) * interItemSpacing) / 2
            }
            for i in 0..<views.count {
                var config = views[i]._config
                config.distanceToTop = startY
                views[i].applyConfig(config)
                startY += (views[i].height + interItemSpacing)
            }
        }
    }

    /// 扩展或收拢触发函数
    ///
    /// - Parameter button: 触发按钮
    @objc private func viewsControlButtonAction(_ button: UIButton) {
        let eView = button.superview! as! EView
        let idx = (views as NSArray).index(of: eView)

        /// 根据模式展开操作子视图
        switch mode! {
        case .one:

            /// 当前展开视图要收拢
            if eView._isExpanded {
                for view in views {
                    view.fold()
                }
            }

            /// 当前视图要展开
            else {
                /// 获取所有的视图的frame值
                var frames = views.map { view in
                    view == eView ? view._expandedFrame! : view._originalFrame!
                }

                calculateFrames(&frames, viewsIndex: idx)

                /// 展开或收拢
                for i in 0..<views.count {
                    if i == idx {
                        views[i].expand(to: frames[i])
                    } else {
                        views[i].contentView.alpha = 0
                        views[i].fold(to: frames[i])
                    }
                }
            }
        case .more:
            var frames = views.map({ view in view._isExpanded ? view._expandedFrame! : view._originalFrame! })
            frames[idx] = eView._isExpanded ? eView._originalFrame : eView._expandedFrame
            calculateFrames(&frames, viewsIndex: idx)

            /// 展开或收拢
            for i in 0..<views.count {
                if i == idx {
                    views[i]._isExpanded ? views[i].fold(to: frames[i]) : views[i].expand(to: frames[i])
                } else {
                    if !views[i]._isExpanded {
                        views[i].contentView.alpha = 0
                        views[i].fold(to: frames[i])
                    } else {
                        views[i].expand(to: frames[i])
                    }
                }
            }
        default:
            var frames = views.map({ view in view._isExpanded ? view._expandedFrame! : view._originalFrame! })
            frames[idx] = eView._isExpanded ? eView._originalFrame : eView._expandedFrame
            calculateFrames(&frames, viewsIndex: idx)
            print("\(_expandedViewsIndex)")

            /// 展开或收拢
            var indexes = [Int](0..<views.count)
            for index in _expandedViewsIndex {
                views[index].expand(to: frames[index])
                indexes.remove(at: (indexes as NSArray).index(of: index))
            }
            for index in indexes {
                views[index].contentView.alpha = 0
                views[index].fold(to: frames[index])
            }
        }
    }

    ///
    @discardableResult
    private func calculateFrames(_ frames: inout [CGRect], viewsIndex idx: Int) -> Bool {
        /// 保存传入的原始frames
        let originalFrames = frames
        let originalExpandedIndexes = _expandedViewsIndex

        /// 根据当前视图展开的frame值，计算前后所有视图的frame值，避免交叉和越过父视图边界
        /// 先计算向前的所有视图
        for i in (0..<idx).reversed() {
            let intersect = frames[i].maxY - frames[i + 1].origin.y
            if intersect > 0 {
                frames[i].origin.y -= (intersect + interItemSpacing)
            } else {
                continue
            }
        }

        /// 再计算后向的所有视图
        for i in idx..<views.count {
            if i != views.count - 1 {
                let intersect = frames[i].maxY - frames[i + 1].origin.y
                if intersect < 0 {
                    continue
                } else {
                    frames[i + 1].origin.y += (intersect + interItemSpacing)
                }
            }
        }

        /// 判断第一个视图是否超过父视图边界
        if frames[0].origin.y < 0 {
            var startY: CGFloat = 0
            for i in 0..<views.count {
                frames[i].origin.y = startY
                startY += (frames[i].height + interItemSpacing)
            }
        }

        /// 判断最后一个视图是否超过父视图边界
        if frames[views.count - 1].maxY > views[0]._parentView.height {
            var startY = views[0]._parentView.height
            for i in (0..<views.count).reversed() {
                startY -= (frames[i].height)
                frames[i].origin.y = startY
                if i != 0 && frames[i].origin.y > frames[i - 1].maxY {
                    break
                }
                startY -= interItemSpacing
            }
        }

        /// 如果是clever模式
        guard mode == .clever else { return true }
        /// 判断是否有视图越过父视图边界
        /// 因为计算了从最后一个视图越界处理，这里只需要判断第一个视图是否越界即可
        if frames[0].minY < 0 {

            /// 回退到计算数据之初
            frames = originalFrames

            /// 如果没有可以收拢的视图，直接返回
            guard _expandedViewsIndex.count != 0 else {
                print("Not enough space to expand the view.")
                frames[idx] = views[idx]._originalFrame
                return false
            }

            /// 还有可以收拢的视图，收拢最早展开的视图，然后再次计算
            let i = _expandedViewsIndex.remove(at: 0)
            frames[i] = views[i]._originalFrame
            if !calculateFrames(&frames, viewsIndex: idx) {
                frames = originalFrames
                frames[idx] = views[idx]._originalFrame
                _expandedViewsIndex = originalExpandedIndexes
                return false
            }
        } else {
            if !views[idx]._isExpanded {
                _expandedViewsIndex += [idx]
            } else {
                _expandedViewsIndex.remove(at: (_expandedViewsIndex as NSArray).index(of: idx))
            }
        }
        return true
    }
}

private extension UIView {

    var x: CGFloat {
        get { return self.frame.origin.x }
        set {
            self.frame.origin.x = newValue
        }
    }
    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            self.frame.origin.y = newValue
        }
    }
    var width: CGFloat {
        get { return self.frame.width }
        set {
            self.frame.size.width = newValue
        }
    }
    var height: CGFloat {
        get { return self.frame.height }
        set {
            self.frame.size.height = newValue
        }
    }

    var size: CGSize {
        get { return self.frame.size }
        set {
            self.frame.size = newValue
        }
    }
}
