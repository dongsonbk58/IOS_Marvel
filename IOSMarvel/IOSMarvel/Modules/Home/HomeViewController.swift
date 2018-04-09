//
//  HomeVC.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/5/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: BaseViewController, AlertViewController {

    @IBOutlet weak var characterCollectionView: UICollectionView!

    var characterList = [Character]()
    var isGrid = true
    var page = 1
    var limit = 10
    var isLoadMore = false
    var isLoading = false
    private let characterRepository: CharacterRepository = CharacterImplement(api: APIService.share)

    override func viewDidLoad() {
        super.viewDidLoad()

        getListCharacter()
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
        switchButton.addTarget(self, action: #selector(switchCollectionView), for: .touchUpInside)
        let rightNavBarButton = UIBarButtonItem(customView: switchButton)
        self.navigationItem.rightBarButtonItem = rightNavBarButton

        characterCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterListCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: "CharacterListCollectionViewCell")
        characterCollectionView.backgroundColor = UIColor.lightGray
    }

    func getListCharacter() {
        self.page = 1
        self.showLoadingOnParent()
        characterRepository.getListCharacter(limit: limit) { (result) in
            switch result {
            case .success(let characterResponse):
                self.characterList.removeAll()
                self.characterList = (characterResponse?.data?.characters)!
                if self.characterList.count < self.limit {
                    self.isLoadMore = false
                } else {
                    self.isLoadMore = true
                }
                self.characterCollectionView.reloadData()
                self.page += 1
                self.hideLoading()
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
                self.hideLoading()
            }
        }
    }

    func loadMoreData() {
        if isLoading {
            return
        }
        self.showLoadingOnParent()
        characterRepository.getListCharacter(limit: self.page * limit) { (result) in
            switch result {
            case .success(let characterResponse):
                let count = self.characterList.count
                var characterArr = [Character]()
                characterArr = (characterResponse?.data?.characters)!
                self.characterList.append(contentsOf: characterArr)
                self.page += 1
                if count < self.characterList.count {
                    self.isLoadMore = true
                } else {
                    self.isLoadMore = false
                }
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
}

// MARK: UICollectionView
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characterDetailVC = CharacterDetailViewController.instantiateFromXib()
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell",
                                                                for: indexPath) as? CharacterCollectionViewCell else {
                 return UICollectionViewCell()
            }
            cell.setContentForCell(character: characterList[indexPath.row])
            if (indexPath.row == self.characterList.count - 1) && (isLoadMore == true) {
                if !isLoading {
                    self.loadMoreData()
                    isLoading = true
                }
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterListCollectionViewCell",
             for: indexPath) as? CharacterListCollectionViewCell else {
                 return UICollectionViewCell()
            }
            cell.setContentForCell(character: characterList[indexPath.row])
            if (indexPath.row == self.characterList.count - 1) && (isLoadMore == true) {
                if !isLoading {
                    self.loadMoreData()
                    isLoading = true
                }
            }
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
            cellItemSize.width = screenWidth/2 - 10
            cellItemSize.height = screenWidth/2 - 10
        } else {
            cellItemSize.width = collectionView.frame.size.width
            cellItemSize.height = 100
        }
        return cellItemSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if isGrid {
            return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        } else {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
}
