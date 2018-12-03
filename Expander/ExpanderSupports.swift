//
//  ExpanderSupports.swift
//  Expander
//
//  Created by yutingLei on 2018/11/27.
//  Copyright © 2018 Develop. All rights reserved.
//
import UIKit

internal extension CGSize {
    static func >(lhs: CGSize, rhs: CGSize) -> Bool {
        return lhs.width > rhs.width && lhs.height > rhs.height
    }
}

internal extension CGRect {
    static func ==(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.minX == rhs.minX && lhs.minY == rhs.minY && lhs.width == rhs.width && lhs.height == rhs.height
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

/// 获取占位图
internal class EHelp {

    static let resourcePath = Bundle(for: EView.self).path(forResource: "Resources", ofType: "bundle")

    /// 获取资源图片
    ///
    /// - Parameter name: 图片名称，若图片不存在，则获取占位图
    /// - Returns: 返回图片对象，获取失败则为nil
    internal static func generateImage(by obj: Any?) -> UIImage? {
        /// Obj is already an image
        if let image = obj as? UIImage {
            return image
        }

        /// 根据传入的图片名称生成图片
        if let name = obj as? String, let image = UIImage(named: name) {
            return image
        }

        /// 生成失败，获取占位图
        if let src = resourcePath {
            return UIImage(contentsOfFile: src + "/picture.png")
        }
        return nil

    }
}
