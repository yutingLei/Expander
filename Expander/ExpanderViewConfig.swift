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
    public var size: CGSize?

    /// View's size, but is Expanded Size.
    /// Default: w=superview.w - padding.left/right, h=120
    public var expandSize: CGSize?

    /// Corner radius for expanded state. default 10
    public var expandCornerRadius: CGFloat?

    /// The offset of EView from the top of its superview.
    /// It means EView's frame.origin.y
    public var distanceToTop: CGFloat?

    /// EView's padding
    public var padding: EViewPadding?

    //MARK: -
    /// which style will be choosed when expanding
    /// Default: .center
    public var expandType: EViewExpandType?

    /// Situated in parent view
    public var located: EViewLocated?

    /// The title/image of state
    /// First param: The title/image in folded state
    /// Second param: The title/image in expanded state
    public var stateFlag: (Any, Any)?

    public init() {}
}

/// The default cell's configuration
public class EViewDatasourceConfig {

    /// Cell mode
    /// titleImage: top title, bottom image
    /// imageTitle: top image, bottom title
    public enum EViewCellMode {
        case titleImage
        case imageTitle
    }
    public var mode: EViewCellMode!

    /// Get values by keys
    public var valueByKeys: [String]!

    /// The cells layout
    /// Default:
    ///         size: w=EView's contentView
    public var layout: UICollectionViewFlowLayout?

    /// The background color for cell's content view. default is white
    public var backgroundColor: UIColor!

    /// The selected color for cell's content view. default is rgb(230, 230, 230)
    public var selectedBackgroundColor: UIColor!

    /// Instance a config
    ///
    /// - Parameter valueByKeys: Get value by key
    public init(keys valueByKeys: [String]!) {
        self.mode = .titleImage
        self.valueByKeys = valueByKeys
        self.backgroundColor = .white
        self.selectedBackgroundColor = UIColor.rgb(230, 230, 230)
    }
}

/// The structure of padding
public struct EViewPadding: CustomStringConvertible {
    public var description: String {
        get {
            return """
            top:    \(self.top)
            left:   \(self.left)
            right:  \(self.right)
            bottom: \(self.bottom)
            """
        }
    }

    /// Top, Left, Bottom, Right
    public var top: CGFloat = 0
    public var left: CGFloat = 0
    public var bottom: CGFloat = 0
    public var right: CGFloat = 0

    /// init
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
}
