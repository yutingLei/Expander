//
//  ViewController.swift
//  ExpanderExample
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit
import Expander

class ViewController: UIViewController {

    var expanderView: EVExpanderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        /// Create an instance of Expander
        expanderView = EVExpanderView.serialization(in: view)
        view.addSubview(expanderView)

        /// Configure Expander
        var layout = EVExpanderViewLayout()
        /// The expander item's size, default is 80x80
        layout.size = CGSize.init(width: 100, height: 100)
        /// The expander expanded size, default is w=superview's width - spacing.left/right, h=120
        layout.expandSize = CGSize.init(width: 200, height: 200)
        /// Decide the expander's y
        layout.distanceToTop = 200
        /// Decide whether the expander is to the left or right of the parent view，default is .left
        layout.location = .right
        /// Decide the distance between expander with it's superview
        layout.padding = EVPadding(left: 20, right: 20)
        /// Apply configuration
        expanderView.applyLayout(layout)

        /// Expand type
        /// others: .center, .down
        expanderView.expandType = .up

        /// 添加数据
        let datas = [["title": "德国", "image": "GM.png"],
                     ["title": "印度", "image": "IN.png"],
                     ["title": "日本", "image": "JP.png"],
                     ["title": "朝鲜", "image": "SK.png"],
                     ["title": "荷兰", "image": "NL.png"],
                     ["title": "英国", "image": "UK.png"],
                     ["title": "美国", "image": "US.png"],
                     ["title": "加拿大", "image": "CA.png"],
                     ["title": "新加坡", "image": "SP.png"]]

        ///
        let config = EVExpanderViewCellConfiguration()
        config.spacing = EVPadding.init(p: 4)
        config.spacingColor = .orange
        config.backgroundColor = .green

        let getValueKeys = ["title", "image"]

        expanderView.applyImageTitles(datas, cellConfiguration: config, withKeys: getValueKeys)
    }


}

