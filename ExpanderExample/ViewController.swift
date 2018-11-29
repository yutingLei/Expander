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

        expanderView = EVExpanderView.serialization(in: view)
        expanderView.applyLayout(EVExpanderViewLayout(expandSize: CGSize.init(width: 300, height: 300)))
        expanderView.expandType = .down
        view.addSubview(expanderView)

        /// 添加数据
        expanderView.applyImageTitles([["title": "德国", "image": "GM.png"],
                                       ["title": "印度", "image": "IN.png"],
                                       ["title": "日本", "image": "JP.png"],
                                       ["title": "朝鲜", "image": "SK.png"],
                                       ["title": "荷兰", "image": "NL.png"],
                                       ["title": "英国", "image": "UK.png"],
                                       ["title": "美国", "image": "US.png"],
                                       ["title": "加拿大", "image": "CA.png"],
                                       ["title": "新加坡", "image": "SP.png"]],
                                      withKeys: "title", "image")
    }


}

