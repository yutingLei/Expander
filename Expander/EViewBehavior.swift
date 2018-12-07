//
//  ExpanderView+Gravity.swift
//  Expander
//
//  Created by yutingLei on 2018/11/28.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit

/// 实现物理行为的扩展
/// 当ExpanderView实现物理行为时，前面设置的一些属性不可用
public extension EView {

    /// 用于保存扩展中的私有变量
    internal struct EVExpanderBehaviorHolder {
        static var animator: UIDynamicAnimator?
        static var behavior: EVExpanderBehavior?
    }

    /// 物理行为导演者
    internal var _animator: UIDynamicAnimator? {
        get { return EVExpanderBehaviorHolder.animator }
        set { EVExpanderBehaviorHolder.animator = newValue }
    }

    /// 物理行为对象
    public private(set) var _behavior: EVExpanderBehavior? {
        get { return EVExpanderBehaviorHolder.behavior }
        set { EVExpanderBehaviorHolder.behavior = newValue }
    }

    /// 添加物理行为到ExpanderView自身
    public func applyDynamicBehavior(_ behavior: EVExpanderBehavior) {
        if _animator == nil {
            assert(superview != nil, "This view must be added to one view before use dynamic behavior!")
            _animator = UIDynamicAnimator(referenceView: superview!)

            /// 添加边界碰撞行为
            let bottomCollision = UICollisionBehavior(items: [self])
            bottomCollision.translatesReferenceBoundsIntoBoundary = true
            var boundary = superview!.frame
            boundary.size.height = boundary.size.height - (behavior.distanceToBottom ?? 0)
            bottomCollision.addBoundary(withIdentifier: "com.expander.collision" as NSCopying, for: UIBezierPath(rect: boundary))
            _animator?.addBehavior(bottomCollision)
        }

        if let gravity = behavior.gravity {
            gravity.addItem(self)
            _animator?.addBehavior(gravity)
        }
        if let collision = behavior.collision {
            collision.addItem(self)
            _animator?.addBehavior(collision)
        }
    }
}

/// 物理引擎行为
public class EVExpanderBehavior: NSObject {

    /// 重力行为
    public var gravity: UIGravityBehavior?

    /// 碰撞行为，针对多个ExpanderView
    public var collision: UICollisionBehavior?

    /// 推动行为
    public var push: UIPushBehavior?

    /// 物理行为底部距离
    public var distanceToBottom: CGFloat?

    /// 添加重力行为
    public func addGravity(with distanceToBottom: CGFloat = 0) {
        self.distanceToBottom = distanceToBottom
        gravity = UIGravityBehavior()
    }

    /// 添加碰撞行为
    public func addCollision(with mode: UICollisionBehavior.Mode = .boundaries) {
        collision = UICollisionBehavior()
        collision?.collisionMode = mode
    }
}
