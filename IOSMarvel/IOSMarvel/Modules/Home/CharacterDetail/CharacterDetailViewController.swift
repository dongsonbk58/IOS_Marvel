//
//  CharacterDetailVC.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit
import ViewPager_Swift

class CharacterDetailViewController: BaseViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var elementsView: UIView!
    @IBOutlet private weak var modifiedLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var seeMoreButton: UIButton!
    @IBOutlet private weak var descriptionHeightContraint: NSLayoutConstraint!
    @IBOutlet private weak var favoriteButton: UIButton!

    var character: Character?
    var heightDescription: CGFloat = 0.0
    var tabs = [
        ViewPagerTab(title: comics, image: nil),
        ViewPagerTab(title: events, image: nil),
        ViewPagerTab(title: series, image: nil),
        ViewPagerTab(title: stories, image: nil)
    ]
    var viewPager: ViewPagerController?
    var options: ViewPagerOptions?
    var clickedSeeMore = false
    var isFavorited = false
    var passFromFavoriteVC = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpViewPager()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        options?.viewPagerFrame = self.elementsView.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func initUI() {
        titleLabel.text = character?.name
        descriptionLabel.text = character?.description
        modifiedLabel.text = character?.modified
        if passFromFavoriteVC {
            guard let avatarUrl = character?.avatarUrl else {
                avatarImageView.image = UIImage(named: avatarDefault)
                return
            }
            avatarImageView.setImageFromURl(stringImageUrl: avatarUrl)
        } else {
            guard let path = character?.thumbnail?.path else {
                avatarImageView.image = UIImage(named: avatarDefault)
                return
            }
            guard let exten = character?.thumbnail?.exten else {
                avatarImageView.image = UIImage(named: avatarDefault)
                return
            }
            avatarImageView.setImageFromURl(stringImageUrl: path + "." + exten)
        }
        if let description = character?.description {
            let descriptionBounds = TextSize.size(description,
                                                  font: UIFont.systemFont(ofSize: 15.0), width: screenWidth - 20)
            if descriptionBounds.height > CGFloat(heightText) {
                seeMoreButton.isHidden = false
                heightDescription = descriptionBounds.height
            } else {
                seeMoreButton.isHidden = true
                descriptionHeightContraint.constant = descriptionBounds.height
            }
        }
        if self.isFavorited {
            favoriteButton.setBackgroundImage(UIImage.init(named: iconHeartFilledWhite), for: .normal)
        } else {
            favoriteButton.setBackgroundImage(UIImage.init(named: iconHeartWhite), for: .normal)
        }
    }

    func setUpViewPager() {
        options = ViewPagerOptions(viewPagerWithFrame: self.elementsView.bounds)
        options?.tabType = ViewPagerTabType.basic
        options?.tabViewTextFont = UIFont.systemFont(ofSize: 16)
        options?.isTabHighlightAvailable = false
        options?.isTabIndicatorAvailable = true
        options?.tabViewBackgroundDefaultColor = UIColor.clear
        options?.tabIndicatorViewBackgroundColor = UIColor.black
        viewPager = ViewPagerController()
        viewPager?.options = options
        viewPager?.dataSource = self
        viewPager?.delegate = self

        if let viewPager = self.viewPager {
            self.addChildViewController(viewPager)
            self.elementsView.addSubview(viewPager.view)
            viewPager.didMove(toParentViewController: self)
        }
    }

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func favoritePressed(_ sender: Any) {
        if let character = self.character {
            let dbManager = DBManager.sharedInstance
            let count = dbManager.getListCharacter().count
            if let characterID = character.characterId {
                if self.isFavorited {
                    dbManager.deleteCharacter(characterID: characterID)
                    favoriteButton.setBackgroundImage(UIImage.init(named: iconHeartWhite), for: .normal)
                    if let tabItems = self.tabBarController?.tabBar.items as NSArray! {
                        if let tabItem = tabItems[1] as? UITabBarItem {
                            tabItem.badgeValue = String(count - 1)
                        }
                    }
                } else {
                    if dbManager.isExist(characterID: characterID) == nil {
                        dbManager.insertCharacter(character: character)
                        favoriteButton.setBackgroundImage(UIImage.init(named: iconHeartFilledWhite), for: .normal)
                        if let tabItems = self.tabBarController?.tabBar.items as NSArray! {
                            if let tabItem = tabItems[1] as? UITabBarItem {
                                tabItem.badgeValue = String(count + 1)
                            }
                        }
                    }
                }
                 self.isFavorited = !self.isFavorited
            }
        }
    }

    @IBAction func seeMorePressed(_ sender: Any) {
        clickedSeeMore = true
        descriptionHeightContraint.constant = heightDescription
        seeMoreButton.isHidden = true
    }
}

extension CharacterDetailViewController: ViewPagerControllerDataSource {
    func numberOfPages() -> Int {
        return tabs.count
    }

    func viewControllerAtPosition(position: Int) -> UIViewController {
        let viewController = ElementViewController.instantiateFromXib()
        viewController.delegate = self
        viewController.characterID = self.character?.characterId
        viewController.elementType = ElementType(rawValue: position)
        viewController.title = "\(tabs[position].title!)"
        return viewController
    }

    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }

    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension CharacterDetailViewController: ViewPagerControllerDelegate {
    func willMoveToControllerAtIndex(index: Int) {

    }

    func didMoveToControllerAtIndex(index: Int) {

    }
}

extension CharacterDetailViewController: ElementVCDelegate {
    func scrollUp() {
        UIView.animate(withDuration: 0.5) {
            self.elementsView.frame = CGRect(x: 0.0, y: CGFloat(heightStatusBar + heightNavigationBar),
                                             width: screenWidth, height: screenHeight)
            self.seeMoreButton.isHidden = true
        }
    }

    func scrollDown() {
        UIView.animate(withDuration: 0.5) {
            self.elementsView.frame = CGRect(x: 0.0, y: self.avatarImageView.frame.size.height +
                self.descriptionLabel.frame.size.height + self.modifiedLabel.frame.size.height + 15.0,
                                             width: screenWidth, height: screenHeight)
            if let description = self.character?.description {
                if description == "" {
                    self.seeMoreButton.isHidden = true
                } else {
                    self.seeMoreButton.isHidden = false
                }
            }
        }
    }
}
