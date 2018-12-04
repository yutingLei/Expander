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

    var expanderView: EView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        /// Create an instance of Expander
        expanderView = EView.serialization(in: view)
        view.addSubview(expanderView)

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
        let config = EViewCellConfig.init(keys: ["title", "image"])
        config.isMultiSelect = true
        config.multiSelectedHandler = { idxs in
            print("Selected indexes: \(idxs)")
        }
        expanderView.showDatas(datas, with: config) { (idx) in
            print("Selected: \(idx)")
        }
    }


}

