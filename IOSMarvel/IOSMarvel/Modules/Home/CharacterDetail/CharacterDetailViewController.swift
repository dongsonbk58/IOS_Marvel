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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var elementsView: UIView!
    @IBOutlet weak var modifiedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var descriptionHeightContraint: NSLayoutConstraint!

    var character: Character?
    var heightDescription: CGFloat = 0.0
    var tabs = [
        ViewPagerTab(title: "Comics", image: nil),
        ViewPagerTab(title: "Events", image: nil),
        ViewPagerTab(title: "Series", image: nil),
        ViewPagerTab(title: "Stories", image: nil)
    ]
    var viewPager: ViewPagerController?
    var options: ViewPagerOptions?
    var clickedSeeMore = false

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
        if let path = character?.thumbnail?.path {
            if let exten = character?.thumbnail?.exten {
                avatarImageView.setImageFromURl(stringImageUrl: path + "." + exten)
            }
        }

        if let description = character?.description {
            let descriptionBounds = TextSize.size(description,
                                                  font: UIFont.systemFont(ofSize: 15.0), width: screenWidth - 20)
            if descriptionBounds.height > 70 {
                seeMoreButton.isHidden = false
                heightDescription = descriptionBounds.height
            } else {
                seeMoreButton.isHidden = true
                descriptionHeightContraint.constant = descriptionBounds.height
            }
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
        viewController.elementType = position
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
