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
    var eGroup: EViewGroup!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        /// Create EView
//        eView = EView.serialization(in: view)
//        view.addSubview(eView)
//
//        /// Custom config
//        var config = EViewConfig()
//        config.size = CGSize(width: 150, height: 150)
//        config.expandSize = CGSize(width: view.bounds.width - 16, height: 300)
//        config.located = .right
//        eView.applyConfig(config)
//
//        /// Show datas
//        let datas = [["title": "德国", "image": "GM.png"],
//                     ["title": "印度", "image": "IN.png"],
//                     ["title": "日本", "image": "JP.png"],
//                     ["title": "朝鲜", "image": "SK.png"],
//                     ["title": "荷兰", "image": "NL.png"],
//                     ["title": "英国", "image": "UK.png"],
//                     ["title": "美国", "image": "US.png"],
//                     ["title": "加拿大", "image": "CA.png"],
//                     ["title": "新加坡", "image": "SP.png"]]
//
//        /// Cell's config
//        let cellConfig = EViewCellConfig(keys: ["title", "image"])
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: (view.bounds.width - 16 - 20) / 4, height: (view.bounds.width - 16 - 20) / 4)
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 4
//        cellConfig.layout = layout
//        eView.showDatas(datas, with: cellConfig) { (idx) in
//            print("Selected: \(idx)")
//        }

        let centerLine = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 1))
        centerLine.backgroundColor = .orange
        centerLine.center = view.center
        view.addSubview(centerLine)

        let view1 = EView.serialization(in: view)
//        var view1Config = EViewConfig()
//        view1Config.located = .right
//        view1Config.expandSize = CGSize.init(width: view.bounds.width - 16, height: 200)
//        view1.applyConfig(view1Config)

        let view2 = EView.serialization(in: view)
        let view3 = EView.serialization(in: view)
        let view4 = EView.serialization(in: view)
        eGroup = EViewGroup.init(layout: .center, mode: .one, with: view1, view2, view3, view4)
        eGroup.interItemSpacing = 8
        eGroup.formed()
    }


}
