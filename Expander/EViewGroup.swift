//
//  EViewGroup.swift
//  EViewGroup
//
//  Created by yutingLei on 2018/12/6.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit

public class EViewGroup {

    /// Subviews arrangement type. note: except for 'viewSelf', other types
    /// will ignore the property named 'distanceToTop'
    ///
    /// - spaceBetween: All views are arranged in equal spacing from the top to the bottom of the parent view,
    ///                 There is no spacing between top-bottom view with it's parent view
    /// - spaceAround: All views are arranged in equal spacing from the top to the bottom of the parent view,
    ///                 There is also have the same spacing between top-bottom view with it's parent view
    /// - center: All views are arranged from center of the parent view.
    /// - start: All views are arranged from top of the parent view.
    /// - end: All views are arranged from bottom of the parent view.
    /// - viewSelf: Use EView-self layout
    public enum EViewGroupLayout {
        case spaceBetween
        case spaceAround
        case center
        case start
        case end
        case viewSelf
    }

    /// Manage how all views are expanded
    ///
    /// - onlyOne: Only one EView expands at the same time
    /// - more: Multiple expanded EViews can exist simultaneously
    /// - clever: In this mode, the expanded view automatically calculates whether
    ///           the parent view boundary is crossed, if crossed, fold other EView
    ///           and calculate again until passed.
    public enum EViewGroupExpande {
        case one
        case more
        case clever
    }

    //MARK: Private vars
    private var _isFormed = false
    /// Record the subscript of the expanded view
    /// It will be used in 'clever' mode.
    private lazy var _expandedViewsIndex: [Int] = {
        return [Int]()
    }()

    //MARK: Public vars
    /// The layout style for EViews
    /// Default is `.center`
    public var layout: EViewGroupLayout
    /// Decide how many EViews can be shown at simultaneously
    /// Default is `.one`
    public var mode: EViewGroupExpande
    /// The managed EViews
    public private(set) var views: [EView]
    /// Spacing between each view
    public var interItemSpacing: CGFloat = 0

    /// Initialize the manager with some parameters
    /// note: required views.cout > 1, and all of the views are must have the same parent view.
    ///
    /// - Parameters:
    ///   - layout: Views arrangement, all the arrangement will be calculated according
    ///             to the order of the array. defautl is '.start'
    ///   - mode: Whether subviews can exist simultaneously when expanded
    ///   - views: The managed views
    public required init(layout: EViewGroupLayout = .start, mode: EViewGroupExpande = .one, with views: EView...) {
        assert(views.count != 0 && views.count > 1, "The count of views must be greater than 1.")
        assert(EViewGroup.isSameParentView(with: views), "All of the views are must have the same parent view.")

        self.layout = layout
        self.mode = mode
        self.views = views
    }

    /// Calling this function means that you have already hosted the views.
    public func formed() {
        guard !_isFormed else {
            print("The 'formed' function can only be called once")
            return
        }
        _isFormed = true

        /// Relayout EViews
        relayoutViews()

        /// Add EView to it's parent view and reset target
        for view in views {
            if view.superview == nil {
                view._parentView.addSubview(view)
            }
            view.controlButton.removeTarget(view, action: nil, for: .touchUpInside)
            view.controlButton.addTarget(self, action: #selector(viewsControlButtonAction(_:)), for: .touchUpInside)
        }
    }
}

extension EViewGroup {

    /// All of the views are must have the same parent view.
    class func isSameParentView(with views: [EView]) -> Bool {
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

    /// Recalculate the layout of the view according to the mode
    func relayoutViews() {

        /// layout == .viewSelf. return directly.
        guard layout != .viewSelf else { return }

        /// Some vars to calculate the layout of the views.
        var startY: CGFloat = 0
        var viewsHeight: CGFloat = 0
        _ = views.map(){ view in viewsHeight += view.height }

        /// Start calculate
        switch layout {
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

    /// The function will be invoked while touched EView's controlButton
    ///
    /// - Parameter button: The touched button
    @objc private func viewsControlButtonAction(_ button: UIButton) {
        let eView = button.superview! as! EView
        let idx = (views as NSArray).index(of: eView)

        /// Start action
        switch mode {
        case .one:

            /// Fold all views
            if eView._isExpanded {
                for view in views {
                    view.fold()
                }
            }

            /// The current EView will be expanded.
            else {
                /// Get all the view's frame
                var frames = views.map { view in
                    view == eView ? view._expandedFrame! : view._originalFrame!
                }

                calculateFrames(&frames, viewsIndex: idx)

                /// Decide the action by idx
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

            /// Decide the action by idx
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

            /// Decide the action by idx
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

    @discardableResult
    private func calculateFrames(_ frames: inout [CGRect], viewsIndex idx: Int) -> Bool {
        /// Save the original values
        let originalFrames = frames
        let originalExpandedIndexes = _expandedViewsIndex

        /// First, calculate the view's 'frame' in front of the current view
        for i in (0..<idx).reversed() {
            let intersect = frames[i].maxY - frames[i + 1].origin.y
            if intersect > 0 {
                frames[i].origin.y -= (intersect + interItemSpacing)
            } else {
                continue
            }
        }

        /// Then, calculate the view's 'frame' behind the current view
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

        /// After calculated, Determine if the first view exceeds the parent view boundary
        if frames[0].origin.y < 0 {
            var startY: CGFloat = 0
            for i in 0..<views.count {
                frames[i].origin.y = startY
                startY += (frames[i].height + interItemSpacing)
            }
        }

        /// Determine if the last view exceeds the parent view boundary
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

        /// when mode == .clever, calculate continuous
        guard mode == .clever else { return true }
        /// Determine if the first view exceeds the parent view boundary once again
        if frames[0].minY < 0 {

            /// Turn back to original 'frames'
            frames = originalFrames

            /// Determine if some view can be folded, if nothing, return directly
            guard _expandedViewsIndex.count != 0 else {
                print("Not enough space to expand the view.")
                frames[idx] = views[idx]._originalFrame
                return false
            }

            /// If some view can be folded, fold the earliest view and then calculate again
            let i = _expandedViewsIndex.remove(at: 0)
            frames[i] = views[i]._originalFrame

            /// Whether to pass this calculation
            if !calculateFrames(&frames, viewsIndex: idx) {
                /// NO! turn 'frames' and '_expandedViewsIndex' back to original values
                frames = originalFrames
                frames[idx] = views[idx]._originalFrame
                _expandedViewsIndex = originalExpandedIndexes
                return false
            }

            /// YES!
        } else {
            if !views[idx]._isExpanded {
                /// Has enough spacing to expand current view. save idx to _expandedViewsIndex
                _expandedViewsIndex += [idx]
            } else {
                /// If fold current view, remove idx from _expandedViewsIndex
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
