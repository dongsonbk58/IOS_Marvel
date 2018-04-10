//
//  ElementViewController.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/10/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

protocol ElementVCDelegate: NSObjectProtocol {
    func scrollUp()
    func scrollDown()
}

class ElementViewController: BaseViewController {

    @IBOutlet weak var elementCollectionView: UICollectionView!
    weak var delegate: ElementVCDelegate?
    var pointTapScroll: CGFloat = 0.0
    var comicList = [Element]()
    var eventList = [Element]()
    var seritList = [Element]()
    var storyList = [Element]()
    var characterID: Int?
    var elementType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func initUI() {
        elementCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil),
                 forCellWithReuseIdentifier: "CharacterCollectionViewCell")
    }
}

// MARK: UICollectionView
extension ElementViewController: UICollectionViewDelegate {

}

extension ElementViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.elementType {
        case 0:
            return comicList.count
        case 1:
            return eventList.count
        case 2:
            return seritList.count
        case 3:
            return storyList.count
        default:
            return comicList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell",
                                                            for: indexPath) as? CharacterCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: UICollectionViewFlowLayout
extension ElementViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellItemSize = collectionView.frame.size
        cellItemSize.width = screenWidth / 2 - 10
        cellItemSize.height = screenWidth / 2 - 10
        return cellItemSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
}

extension ElementViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointTapScroll = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > pointTapScroll { // scroll up
            self.delegate?.scrollUp()
        } else { // scroll down
            self.delegate?.scrollDown()
        }
    }
}
