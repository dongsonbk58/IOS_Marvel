//
//  FavoriteVC.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/5/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func initUI() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth - 70, height: 25))
        searchBar.placeholder = "Search"
        let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.backgroundColor = .black
        searchTextField?.textColor = .white
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton

        let switchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let switchImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        switchImageView.image = UIImage.init(named: "change")
        switchImageView.contentMode = .scaleAspectFit
        switchButton.addSubview(switchImageView)
        let rightNavBarButton = UIBarButtonItem(customView: switchButton)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
}
