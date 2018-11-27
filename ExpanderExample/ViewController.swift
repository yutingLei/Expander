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
        expanderView.layout = .right
        expanderView.titleLabel.text = "折叠"
        expanderView.expandType = .down
        view.addSubview(expanderView)
    }


}

