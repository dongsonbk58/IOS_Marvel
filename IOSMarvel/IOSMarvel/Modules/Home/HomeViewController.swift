//
//  HomeVC.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/5/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class HomeViewController: BaseViewController, AlertViewController {

    @IBOutlet private weak var characterCollectionView: UICollectionView!
    @IBOutlet private weak var noDataLabel: UILabel!

    var characterList = [Character]()
    var isGrid = true
    var page = 0
    var isLoadMore = false
    var isLoading = false
    private let characterRepository: CharacterRepository = CharacterImplement(api: APIService.share)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        getListCharacter()
    }

    override func initUI() {
        setUpSearchBar()
        setUpSwitchButton()
        setUpColectionView()
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
        characterCollectionView.register(UINib(nibName: characterCollectionViewCell, bundle: nil),
                                         forCellWithReuseIdentifier: characterCollectionViewCell)
        characterCollectionView.register(UINib(nibName: characterListCollectionViewCell, bundle: nil),
                                         forCellWithReuseIdentifier: characterListCollectionViewCell)
        characterCollectionView.backgroundColor = UIColor.lightGray
        noDataLabel.isHidden = true
    }

    func handleSuccessListCharacter(characterResponse: CharacterResponse?) {
        self.characterList.removeAll()
        if let characterList = characterResponse?.data?.characters {
            self.characterList = characterList
            self.isLoadMore = self.characterList.count < limit ? false : true
            for i in 0..<characterList.count {
                if let characterId = characterList[i].characterId {
                    if appDelegate().characterIdList.contains(characterId) {
                        characterList[i].isFavorited = true
                    }
                }
            }
            noDataLabel.isHidden = self.characterList.isEmpty ? false : true
            self.characterCollectionView.reloadData()
            self.page += 1
        }
    }

    func getListCharacter() {
        self.page = 0
        self.showLoadingOnParent()
        characterRepository.getListCharacter(page: self.page) { (result) in
            switch result {
            case .success(let characterResponse):
                self.handleSuccessListCharacter(characterResponse: characterResponse)
                self.hideLoading()
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
                self.hideLoading()
            }
        }
    }

    func searchCharacter(name: String) {
        self.page = 0
        characterRepository.searchCharacter(page: self.page, name: name) { (result) in
            switch result {
            case .success(let characterResponse):
                self.handleSuccessListCharacter(characterResponse: characterResponse)
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
            }
        }
    }

    func loadMoreData() {
        if isLoading {
            return
        }
        self.showLoadingOnParent()
        characterRepository.getListCharacter(page: self.page) { (result) in
            switch result {
            case .success(let characterResponse):
                let count = self.characterList.count
                var characterArr = [Character]()
                characterArr = (characterResponse?.data?.characters)!
                self.characterList.append(contentsOf: characterArr)
                self.page += 1
                self.isLoadMore = count < self.characterList.count ? true : false
                self.characterCollectionView.reloadData()
                self.isLoading = false
                self.hideLoading()
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
                self.hideLoading()
            }
        }
    }

    @objc func switchCollectionView() {
        self.isGrid = !self.isGrid
        self.characterCollectionView.reloadData()
    }

    func favoriteCharacter(character: Character, isFavorited: Bool, atIndexPath: IndexPath) {
        let dbManager = DBManager.sharedInstance
        let characterChange = self.characterList[atIndexPath.row]
        let count = dbManager.getListCharacter().count
        if let characterID = character.characterId {
            if isFavorited {
                // delete
                dbManager.deleteCharacter(characterID: characterID)
                if let tabItems = self.tabBarController?.tabBar.items as NSArray! {
                    if let tabItem = tabItems[1] as? UITabBarItem {
                        tabItem.badgeValue = String(count - 1)
                    }
                }
                characterChange.isFavorited = false
                self.characterList[atIndexPath.row] = characterChange
                self.characterCollectionView.reloadData()
            } else {
                // insert
                if dbManager.isExist(characterID: characterID) == nil {
                    dbManager.insertCharacter(character: character)
                    if let tabItems = self.tabBarController?.tabBar.items as NSArray! {
                        if let tabItem = tabItems[1] as? UITabBarItem {
                            tabItem.badgeValue = String(count + 1)
                        }
                    }
                }
                characterChange.isFavorited = true
                self.characterList[atIndexPath.row] = characterChange
                self.characterCollectionView.reloadData()
            }
        }
    }
}

// MARK: UICollectionView
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characterDetailVC = CharacterDetailViewController.instantiateFromXib()
        characterDetailVC.character = characterList[indexPath.row]
        if let isFavorited = characterList[indexPath.row].isFavorited {
            characterDetailVC.isFavorited = isFavorited
        }
        self.navigationController?.pushViewController(characterDetailVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
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
            cell.setContentForCell(character: characterList[indexPath.row], atIndexPath: indexPath)
            if (indexPath.row == self.characterList.count - 1) && isLoadMore {
                if !isLoading {
                    self.loadMoreData()
                    isLoading = true
                }
            }
            cell.onCompletionFavorite = { [weak self] (characterObject, isFavorited, indexPath) in
                self?.favoriteCharacter(character: characterObject, isFavorited: isFavorited, atIndexPath: indexPath)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: characterListCollectionViewCell,
             for: indexPath) as? CharacterListCollectionViewCell else {
                 return UICollectionViewCell()
            }
            cell.setContentForCell(character: characterList[indexPath.row], atIndexPath: indexPath)
            if (indexPath.row == self.characterList.count - 1) && isLoadMore {
                if !isLoading {
                    self.loadMoreData()
                    isLoading = true
                }
            }
            cell.delegate = self
            return cell
        }
    }
}

// MARK: UICollectionViewFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
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

extension HomeViewController: CharacterListCollectionViewCellDelegate {
    func favoritePressed(character: Character, isFavorited: Bool, atIndexPath: IndexPath) {
        self.favoriteCharacter(character: character, isFavorited: isFavorited, atIndexPath: atIndexPath)
    }
}

// MARK: Searchbar
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.searchCharacter(name: searchText)
        } else {
            self.getListCharacter()
        }
    }
}
