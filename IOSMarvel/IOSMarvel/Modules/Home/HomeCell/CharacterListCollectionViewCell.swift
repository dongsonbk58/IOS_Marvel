//
//  CharacterListCollectionViewCell.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

protocol CharacterListCollectionViewCellDelegate: NSObjectProtocol {
    func favoritePressed(character: Character, isFavorited: Bool, atIndexPath: IndexPath)
}

class CharacterListCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var avatarImageVIew: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    var indexPath: IndexPath?
    var isFavorited = false

    weak var delegate: CharacterListCollectionViewCellDelegate?
    var character: Character?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setFavourited(isFavourite: false)
    }

    func setFavourited(isFavourite: Bool) {
        self.isFavorited = isFavourite
        favoriteButton?.isHidden = false
        if isFavourite {
            favoriteButton?.setBackgroundImage(UIImage.init(named: iconHeartFilledList), for: .normal)
        } else {
            favoriteButton?.setBackgroundImage(UIImage(named: iconHeartList), for: .normal)
        }
    }

    func setContentForCell(character: Character, atIndexPath: IndexPath) {
        self.character = character
        self.indexPath = atIndexPath
        setFavourited(isFavourite: character.isFavorited ?? false)
        if let name = character.name {
            nameLabel.text = name
        }
        if let description = character.description {
            descriptionLabel.text = description
        }
        guard let path = character.thumbnail?.path else {
            avatarImageVIew.image = UIImage(named: avatarDefault)
            return
        }
        guard let exten = character.thumbnail?.exten else {
            avatarImageVIew.image = UIImage(named: avatarDefault)
            return
        }
        avatarImageVIew.setImageFromURl(stringImageUrl: "\(path)." + "\(exten)")
    }

    func setContentFavoriteForCell(character: Character) {
        self.character = character
        setFavourited(isFavourite: true)
        if let name = character.name {
            nameLabel.text = name
        }
        guard let avatarUrl = character.avatarUrl else {
            avatarImageVIew.image = UIImage(named: avatarDefault)
            return
        }
        avatarImageVIew.setImageFromURl(stringImageUrl: avatarUrl)
    }

    @IBAction func favoritePressed(_ sender: Any) {
        if let characterObject = self.character {
            if let indexPath = self.indexPath {
                self.delegate?.favoritePressed(character: characterObject, isFavorited: self.isFavorited,
                                               atIndexPath: indexPath)
            }
        }
    }
}
