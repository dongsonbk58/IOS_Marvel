//
//  FavoriteVC.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/5/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {

    @IBOutlet private weak var favoriteCollectionView: UICollectionView!
    @IBOutlet private weak var noDataLabel: UILabel!
    var pointTapScroll: CGFloat = 0.0

    var isGrid = true
    var characterList = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        getCharacterFromDB()
    }

    func getCharacterFromDB() {
        characterList = DBManager.sharedInstance.getListCharacter()
        noDataLabel.isHidden = !characterList.isEmpty
        favoriteCollectionView.reloadData()
    }

    func searchCharacter(name: String) {
        characterList = DBManager.sharedInstance.searchCharacter(name: name)
        noDataLabel.isHidden = !characterList.isEmpty
        favoriteCollectionView.reloadData()
    }

    func setUpSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: CGFloat(edgeList), y: CGFloat(edgeList),
                                                  width: CGFloat(widthSearchBar), height: CGFloat(heightSearchBar)))
        searchBar.placeholder = search
        let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.backgroundColor = .black
        searchTextField?.textColor = .white
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }

    func setUpSwitchButton() {
        let switchButton = UIButton(frame: CGRect(x: CGFloat(edgeList), y: CGFloat(edgeList),
                                                  width: CGFloat(widthSwitchButton),
                                                  height: CGFloat(widthSwitchButton)))
        let switchImageView = UIImageView(frame: CGRect(x: CGFloat(edgeList), y: CGFloat(edgeList),
                                                        width: CGFloat(widthSwitchImageView),
                                                        height: CGFloat(widthSwitchImageView)))
        switchImageView.image = UIImage.init(named: iconSwitchButton)
        switchImageView.contentMode = .scaleAspectFit
        switchButton.addSubview(switchImageView)
        switchButton.addTarget(self, action: #selector(switchCollectionView), for: .touchUpInside)
        let rightNavBarButton = UIBarButtonItem(customView: switchButton)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }

    func setUpColectionView() {
        favoriteCollectionView.register(UINib(nibName: characterCollectionViewCell, bundle: nil),
                                        forCellWithReuseIdentifier: characterCollectionViewCell)
        favoriteCollectionView.register(UINib(nibName: characterListCollectionViewCell, bundle: nil),
                                        forCellWithReuseIdentifier: characterListCollectionViewCell)
        favoriteCollectionView.backgroundColor = UIColor.lightGray
        noDataLabel.isHidden = true
    }

    override func initUI() {
        setUpSearchBar()
        setUpSwitchButton()
        setUpColectionView()
    }

    @objc func switchCollectionView() {
        self.isGrid = !self.isGrid
        self.favoriteCollectionView.reloadData()
    }

    func deleteCharacterFromFavorite(character: Character, isFavorited: Bool, atIndexPath: IndexPath) {
        let dbManager = DBManager.sharedInstance
        guard let badgeValue = self.navigationController?.tabBarItem.badgeValue else { return }
        let count = Int(badgeValue) ?? 0
        if let characterID = character.characterId {
            dbManager.deleteCharacter(characterID: characterID)
            self.characterList = dbManager.getListCharacter()
            self.navigationController?.tabBarItem.badgeValue = String(count - 1)
            noDataLabel.isHidden = !characterList.isEmpty
            favoriteCollectionView.reloadData()
        }
    }
}

// MARK: UICollectionView
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characterDetailVC = CharacterDetailViewController.instantiateFromXib()
        characterDetailVC.character = characterList[indexPath.row]
        characterDetailVC.isFavorited = true
        characterDetailVC.passFromFavoriteVC = true
        self.navigationController?.pushViewController(characterDetailVC, animated: true)
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGrid {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: characterCollectionViewCell,
                                                                for: indexPath) as? CharacterCollectionViewCell else {
                                                                    return UICollectionViewCell()
            }
            cell.setContentFavoriteForCell(character: characterList[indexPath.row], atIndexPath: indexPath)
            cell.onCompletionFavorite = { [weak self] (characterObject, isFavorited, indexPath) in
                guard let `self` = self else { return }
                self.deleteCharacterFromFavorite(character: characterObject,
                                                  isFavorited: isFavorited, atIndexPath: indexPath)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                characterListCollectionViewCell, for: indexPath) as? CharacterListCollectionViewCell else {
                    return UICollectionViewCell()
            }
            cell.setContentFavoriteForCell(character: characterList[indexPath.row], atIndexPath: indexPath)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: UICollectionViewFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellItemSize = collectionView.frame.size
        if isGrid {
            cellItemSize.width = screenWidth / 2 - 10
            cellItemSize.height = screenWidth / 2 - 10
        } else {
            cellItemSize.width = collectionView.frame.size.width
            cellItemSize.height = CGFloat(heightCellList)
        }
        return cellItemSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if isGrid {
            return UIEdgeInsets(top: CGFloat(edgeGrid), left: CGFloat(edgeGrid),
                                bottom: CGFloat(edgeGrid), right: CGFloat(edgeGrid))
        } else {
            return UIEdgeInsets(top: CGFloat(edgeList), left: CGFloat(edgeList),
                                bottom: CGFloat(edgeList), right: CGFloat(edgeList))
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isGrid {
            return CGFloat(lineSpacingGrid)
        } else {
            return CGFloat(lineSpacingList)
        }
    }
}

extension FavoriteViewController: CharacterListCollectionViewCellDelegate {
    func favoritePressed(character: Character, isFavorited: Bool, atIndexPath: IndexPath) {
        self.deleteCharacterFromFavorite(character: character, isFavorited: isFavorited, atIndexPath: atIndexPath)
    }
}

// MARK: Searchbar
extension FavoriteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchCharacter(name: searchText)
        } else {
            getCharacterFromDB()
        }
    }
}

extension FavoriteViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointTapScroll = scrollView.contentOffset.y
    }

    func hideTabBar() {
        guard let tabbarController = self.tabBarController else {
            return
        }
        var frame = tabbarController.tabBar.frame
        frame.origin.y = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.5, animations: {
            tabbarController.tabBar.frame = frame
        })
    }

    func showTabBar() {
        guard let tabbarController = self.tabBarController else {
            return
        }
        var frame = tabbarController.tabBar.frame
        frame.origin.y = UIScreen.main.bounds.height - frame.size.height
        UIView.animate(withDuration: 0.5, animations: {
            tabbarController.tabBar.frame = frame
        })
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > pointTapScroll { // scroll up
            showTabBar()
        } else { // scroll down
            hideTabBar()
        }
    }
}
