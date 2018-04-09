//
//  BaseViewController.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/5/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initUI() {

    }

    func showLoadingOnParent() {
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "", messageFont: nil, type: NVActivityIndicatorType(rawValue: 14)!,
                       color: .black, padding: 0, displayTimeThreshold: 0,
                       minimumDisplayTime: 0, backgroundColor: .clear, textColor: .black)
    }

    func hideLoading() {
        self.stopAnimating()
    }
}
