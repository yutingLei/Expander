//
//  ExpanderSupports.swift
//  Expander
//
//  Created by yutingLei on 2018/11/27.
//  Copyright © 2018 Develop. All rights reserved.
//
import UIKit

/// Compare CGSize
internal extension CGSize {
    static func >(lhs: CGSize, rhs: CGSize) -> Bool {
        return lhs.width > rhs.width && lhs.height > rhs.height
    }
}

/// Compare CGRect
internal extension CGRect {
    static func ==(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.minX == rhs.minX && lhs.minY == rhs.minY && lhs.width == rhs.width && lhs.height == rhs.height
    }
}

/// Generate color with r/g/b
extension UIColor {
    public class func rgb(_ rgb: CGFloat...) -> UIColor {
        assert(rgb.count == 3, "Invalide values of rgb, it must contain three values.")
        let rgbs = rgb.map({ $0 / 255.0 })
        return UIColor(red: rgbs[0], green: rgbs[1], blue: rgbs[2], alpha: 1)
    }
}

/// Get placeholder image
internal class EHelp {

    /// Resource path
    static let resourcePath = Bundle(for: EView.self).path(forResource: "Resources", ofType: "bundle")

    /// Get image
    ///
    /// - Parameter name: image name or path
    /// - Returns: An image object
    internal static func generateImage(by obj: Any?) -> UIImage? {
        /// Obj is already an image
        if let image = obj as? UIImage {
            return image
        }

        /// Get image by name
        if let name = obj as? String, let image = UIImage(named: name) {
            return image
        }

        /// Get image by name. internal
        if let src = resourcePath, let name = obj as? String {
            return UIImage(contentsOfFile: src + "/\(name).png")
        }
        return nil

    }
}

/// Calculate string's size
internal extension String {
    func width(_ limitHeight: CGFloat, fontSize: CGFloat = 15) -> CGFloat {
        let size = CGSize.init(width: CGFloat.infinity, height: limitHeight)
        let rect = (self as NSString).boundingRect(with: size,
                                                   options: .truncatesLastVisibleLine,
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)],
                                                   context: nil)
        return rect.width
    }
}
