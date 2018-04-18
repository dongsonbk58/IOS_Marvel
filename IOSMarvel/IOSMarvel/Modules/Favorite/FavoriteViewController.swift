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

    var isGrid = true
    var characterList = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        characterList = DBManager.sharedInstance.getListCharacter()
        noDataLabel.isHidden = characterList.isEmpty ? false : true
        favoriteCollectionView.reloadData()
    }

    func setUpSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth - 70, height: 25))
        searchBar.placeholder = "Search"
        let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.backgroundColor = .black
        searchTextField?.textColor = .white
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }

    func setUpSwitchButton() {
        let switchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let switchImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        switchImageView.image = UIImage.init(named: iconSwitchButton)
        switchImageView.contentMode = .scaleAspectFit
        switchButton.addSubview(switchImageView)
        switchButton.addTarget(self, action: #selector(switchCollectionView), for: .touchUpInside)
        let rightNavBarButton = UIBarButtonItem(customView: switchButton)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }

    func setUpColectionView() {
        favoriteCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil),
                                        forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        favoriteCollectionView.register(UINib(nibName: "CharacterListCollectionViewCell", bundle: nil),
                                        forCellWithReuseIdentifier: "CharacterListCollectionViewCell")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell",
                                                                for: indexPath) as? CharacterCollectionViewCell else {
                                                                    return UICollectionViewCell()
            }
            cell.setContentFavoriteForCell(character: characterList[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                "CharacterListCollectionViewCell", for: indexPath) as? CharacterListCollectionViewCell else {
                    return UICollectionViewCell()
            }
            cell.setContentFavoriteForCell(character: characterList[indexPath.row])
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

extension FavoriteViewController: CharacterListCollectionViewCellDelegate {
    func favoritePressed(character: Character, isFavorited: Bool, atIndexPath: IndexPath) {
        let dbManager = DBManager.sharedInstance
        let count = Int((self.navigationController?.tabBarItem.badgeValue)!) ?? 0
        if let characterID = character.characterId {
            dbManager.deleteCharacter(characterID: characterID)
            self.characterList = dbManager.getListCharacter()
            self.navigationController?.tabBarItem.badgeValue = String(count - 1)
            noDataLabel.isHidden = characterList.isEmpty ? false : true
            favoriteCollectionView.reloadData()
        }
    }
}
