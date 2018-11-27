//
//  ExpanderSupports.swift
//  Expander
//
//  Created by Conjur on 2018/11/27.
//  Copyright © 2018 Develop. All rights reserved.
//
import UIKit

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

/// 根据RGB生成颜色
extension UIColor {
    public class func rgb(_ rgb: CGFloat...) -> UIColor {
        assert(rgb.count == 3, "Invalide values of rgb, it must contain three values.")
        let rgbs = rgb.map({ $0 / 255.0 })
        return UIColor(red: rgbs[0], green: rgbs[1], blue: rgbs[2], alpha: 1)
    }
}
