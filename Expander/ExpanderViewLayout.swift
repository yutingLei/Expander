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

    /// 初始视图大小，默认80x80
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
                padding: EVPadding = EVPadding(p: 0, 8),
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

/// Cell布局类
public class EVExpanderViewCellConfiguration: UICollectionViewFlowLayout {

    /// cell边缘填充，默认4，content的大小=size - spacing
    public var spacing: EVPadding = EVPadding(p: 4) {
        willSet {
            minimumLineSpacing = newValue.left
            minimumInteritemSpacing = newValue.top
        }
    }

    /// 填充区域的颜色，默认rgb(230, 230, 230)
    public var spacingColor: UIColor = UIColor.rgb(240, 240, 240)

    /// 内容视图的背景色，默认白色
    public var backgroundColor: UIColor = .white

    /// 选中后的背景色，不设置表示选中前后一致
    public var selectedBackgroundColor: UIColor?

    /// 初始化
    public override init() {
        super.init()
        itemSize = CGSize(width: 86, height: 86)
        scrollDirection = .horizontal
        minimumLineSpacing = 4
        minimumInteritemSpacing = 4
    }

    /// 初始化出错
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 决定ExpanderView上左下右边距
public struct EVPadding {
    /// 上边距
    public var top: CGFloat = 0

    /// 下边距
    public var bottom: CGFloat = 0

    /// 左边距
    public var left: CGFloat = 0

    /// 右边距
    public var right: CGFloat = 0

    /// 初始化1
    public init(p: CGFloat...) {
        switch p.count {
        case 1:
            top = p[0]
            left = p[0]
            bottom = p[0]
            right = p[0]
        case 2:
            top = p[0]
            left = p[1]
            bottom = p[0]
            right = p[1]
        case 3:
            top = p[0]
            left = p[1]
            bottom = p[2]
            right = p[1]
        case 4:
            top = p[0]
            left = p[1]
            bottom = p[2]
            right = p[3]
        default:
            break
        }
    }

    /// 初始化2
    public init(left: CGFloat, right: CGFloat, top: CGFloat = 0, bottom: CGFloat = 0) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}
