//
//  ExpanderViewLayout.swift
//  Expander
//
//  Created by yutingLei on 2018/11/28.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit

/// The expander view's configuration
public struct EViewConfig {

    /// Expand type
    /// up: fixed view's maxY, expand upward
    /// center: fixed view's midY, expand to both sides. default
    /// down: fixed view's minY, expand downward
    public enum EViewExpandType {
        case up
        case center
        case down
    }

    /// Location
    public enum EViewLocated {
        case left
        case right
    }

    //MARK: The view's layout
    /// View's size, origin size, default 80x80
    public var size: CGSize

    /// View's size, but is Expanded Size.
    /// Default: width=superview.w - padding.left/right, height=120
    /// Note: if width less than 0, use default width
    ///       if height less than 0, use default height
    public var expandSize: CGSize?

    /// Corner radius for expanded state. default 10
    public var expandCornerRadius: CGFloat

    /// The offset of EView from the top of its superview.
    /// It means EView's frame.origin.y
    /// If nil or less than 0, EView will be centered(axis y) in parent view
    public var distanceToTop: CGFloat?

    /// EView's padding
    public var padding: EViewPadding

    //MARK: -
    /// which style will be choosed when expanding
    /// Default: .center
    public var expandType: EViewExpandType

    /// Situated in parent view
    /// Default: .left
    public var located: EViewLocated

    /// The title/image of state
    /// First param: The title/image in folded state
    /// Second param: The title/image in expanded state
    public var stateFlag: (Any, Any)?

    /// If true, no matter how you move the EView, it will return to the original position after
    /// the finger is released.
    public var isViscosity: Bool?

    public init(size: CGSize = CGSize(width: 80, height: 80),
                expandCornerRadius: CGFloat = 10,
                padding: EViewPadding = EViewPadding(0, 8),
                expandType: EViewExpandType = .center,
                located: EViewLocated = .left)
    {
        self.size = size
        self.padding = padding
        self.located = .left
        self.expandType = expandType
        self.expandCornerRadius = expandCornerRadius
    }
}

/// The default cell's configuration
public class EViewCellConfig {

    /// The cell's mode to decide which style will be used to layout subviews
    ///
    /// - `default`: Top with a title label, bottom with an image view
    /// - classic: Top with an image view, bottom with a title label
    public enum EViewCellMode {
        case `default`
        case classic
    }
    public var mode: EViewCellMode = .`default`

    /// If multiple select. default is false
    public var isMultiSelect: Bool {
        willSet {
            sureTitle = sureTitle ?? "Sure"
            selectedImage = selectedImage ?? (newValue ? EHelp.generateImage(by: "e-correct") : nil)
        }
    }

    /// The title for sure button (only support multiple select)
    public var sureTitle: String?
    /// The sure button has clicked.
    public var multiSelectedHandler: (([Int]) -> Void)?

    /// The cell's background color. default is white
    public var backgroundColor: UIColor = .white

    /// The cell's background color when selected
    /// Only isMultiSelect is false.
    public var selectedBackgroundColor: UIColor?

    /// The image will be shown on the cell's content view when selected
    /// Only isMultiSelect is true. then ignore selectedBackgroundColor
    public var selectedImage: UIImage?

    /// Get title label's text and image view's image or image name
    /// The first key must for title, and the second key must for image
    public private(set) var valueByKeys: [String]!

    /// The cells layout
    /// Default:
    ///         size: w=EView's contentView=h
    public var layout: UICollectionViewFlowLayout?

    /// Instance a config
    ///
    /// - Parameter valueByKeys: Get value by key
    public init(keys valueByKeys: [String], isMultiSelect: Bool = false) {
        self.valueByKeys = valueByKeys
        self.isMultiSelect = isMultiSelect
    }
}

/// The structure of padding
public struct EViewPadding {

    /// Top, Left, Bottom, Right
    public var top: CGFloat = 0
    public var left: CGFloat = 0
    public var bottom: CGFloat = 0
    public var right: CGFloat = 0

    /// Init padding
    ///
    /// - Parameter ps: top/left/bottom/right values in order
    /// Note: if ps.count
    ///       =1             top/left/bottom/right are equal ps[0]
    ///       =2             top/bottom equal ps[0], others equal ps[1]
    ///       =3             top equal ps[0], bottom equal ps[2], others equal ps[1]
    ///       =4             apply values in order
    public init(_ ps: CGFloat...) {
        switch ps.count {
        case 1:
            top = ps[0]; left = ps[0]; bottom = ps[0]; right = ps[0]
        case 2:
            top = ps[0]; bottom = ps[0]
            left = ps[1]; right = ps[1]
        case 3:
            top = ps[0]; bottom = ps[2]
            left = ps[1]; right = ps[1]
        case 4:
            top = ps[0]; bottom = ps[2]
            left = ps[1]; right = ps[3]
        default:
            break
        }
    }

    /// Get paddings of left and right
    ///
    /// - Returns: the left + right padding's value
    public func leftRight() -> CGFloat {
        return left + right
    }
}
