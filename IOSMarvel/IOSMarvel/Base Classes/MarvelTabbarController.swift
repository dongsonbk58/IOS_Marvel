//
//  MarverTabbarCOntroller.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/5/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

class MarvelTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupTabbarDatasource()
        setupTabbarUI()
    }

    fileprivate func setupTabbarDatasource() {
        UITabBar.appearance().selectionIndicatorImage = self.makeImageWithColorAndSize(color: UIColor.black,
        size: CGSize(width: screenWidth/2, height: CGFloat(heightTabbar)))
        self.viewControllers = [self.setTabbarItemHome(), self.setTabbarItemFavorite()]
    }

    fileprivate func setupTabbarUI() {
        tabBar.isTranslucent = true
        tabBar.barTintColor = UIColor.white
        configureImageTabbarItem()
    }

    fileprivate func configureImageTabbarItem() {
        guard let itemsTabbar = tabBar.items else { return }
        for item in itemsTabbar {
            item.title = ""
            item.imageInsets = UIEdgeInsets(top: 6.0, left: 0, bottom: -6.0, right: 0)
        }
    }

    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image != nil ? image! : UIImage()
    }

    func setTabbarItemHome() -> UINavigationController {
        let homeVC = HomeViewController.instantiateFromXib()
        let homeNav = UINavigationController.init(rootViewController: homeVC)
        let homeTabbar = UITabBarItem()
        homeTabbar.tag = 0
        homeTabbar.image = UIImage(named: "icn_feed_unSelected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        homeTabbar.selectedImage = UIImage(named: "icn_feed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        homeNav.tabBarItem = homeTabbar
        return homeNav
    }

    func setTabbarItemFavorite() -> UINavigationController {
        let favoriteVC = FavoriteViewController.instantiateFromXib()
        let favoriteNav = UINavigationController.init(rootViewController: favoriteVC)
        let favoriteTabbar = UITabBarItem()
        favoriteTabbar.tag = 1
        favoriteTabbar.image = UIImage(named: "icn_noti_unSelected")?
            .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        favoriteTabbar.selectedImage = UIImage(named: "icn_noti")?
            .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        favoriteNav.tabBarItem = favoriteTabbar
        return favoriteNav
    }
}
