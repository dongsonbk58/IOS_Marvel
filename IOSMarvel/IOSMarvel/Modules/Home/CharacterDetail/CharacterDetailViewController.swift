//
//  CharacterDetailVC.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

class CharacterDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
