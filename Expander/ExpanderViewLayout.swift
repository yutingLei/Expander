//
//  ExpanderViewLayout.swift
//  Expander
//
//  Created by yutingLei on 2018/11/28.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit

/// 用于实现视图的排列坐标
public struct EVExpanderViewLayout {

    /// 排列区域枚举
    public enum EVLocation {
        case left
        case right
    }

    /// 初始视图大小
    public var size: CGSize!
    /// 视图展开大小，若未设置，则默认：宽度=父视图宽度-两边padding; 高度=120
    public var expandSize: CGSize?
    /// 两边填充距离，可以理解为边距, 默认左右边距为8
    public var padding: EVPadding!
    /// 排列区域
    public var location: EVLocation!
    /// 视图距离父视图顶部位置，若未设置，则默认视图位于父视图中部
    public var distanceToTop: CGFloat?

    /// 初始化排列
    public init(size: CGSize = CGSize(width: 80, height: 80),
                expandSize: CGSize? = nil,
                padding: EVPadding = EVPadding(p: 8),
                location: EVLocation = .left,
                distanceToTop: CGFloat? = nil)
    {
        self.size = size
        self.expandSize = expandSize
        self.padding = padding
        self.location = location
        self.distanceToTop = distanceToTop
    }
}

/// 决定ExpanderView左右边距
public struct EVPadding {

    /// 左边距
    public var left: CGFloat = 0

    /// 右边距
    public var right: CGFloat = 0

    /// 初始化1
    public init(p: CGFloat) {
        left = p
        right = p
    }

    /// 初始化2
    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
}
