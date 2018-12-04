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

    var eView: EView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        /// Create EView
        eView = EView.serialization(in: view)
        view.addSubview(eView)

        /// Custom config
        var config = EViewConfig()
        config.size = CGSize(width: 150, height: 150)
        config.expandSize = CGSize(width: view.bounds.width - 16, height: 300)
        config.located = .right
        eView.applyConfig(config)

        /// Show datas
        let datas = [["title": "德国", "image": "GM.png"],
                     ["title": "印度", "image": "IN.png"],
                     ["title": "日本", "image": "JP.png"],
                     ["title": "朝鲜", "image": "SK.png"],
                     ["title": "荷兰", "image": "NL.png"],
                     ["title": "英国", "image": "UK.png"],
                     ["title": "美国", "image": "US.png"],
                     ["title": "加拿大", "image": "CA.png"],
                     ["title": "新加坡", "image": "SP.png"]]

        /// Cell's config
        let cellConfig = EViewCellConfig(keys: ["title", "image"])
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.bounds.width - 16 - 20) / 4, height: (view.bounds.width - 16 - 20) / 4)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        cellConfig.layout = layout
        eView.showDatas(datas, with: cellConfig) { (idx) in
            print("Selected: \(idx)")
        }
    }


}
