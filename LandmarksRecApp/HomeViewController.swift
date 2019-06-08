//
//  HomeViewController.swift
//  This is the Welcome page controller.
//  LandmarksRecApp
//
//  Created by Zhiqin Zhang on 2019/5/5.
//  Copyright © 2019 Zhiqin Zhang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named:"background")?.cgImage
    }

}
