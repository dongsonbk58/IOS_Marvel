//
//  CharacterCollectionViewCell.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    var character: Character?
    var isFavorited = false
    var indexPath: IndexPath?
    var onCompletionFavorite: ((_ character: Character, _ isFavorited: Bool, _ atIndexPath: IndexPath) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setFavourited(isFavourite: false)
    }

    func setContentForCell(character: Character, atIndexPath: IndexPath) {
        self.character = character
        self.indexPath = atIndexPath
        setFavourited(isFavourite: character.isFavorited ?? false)
        if let name = character.name {
            nameLabel.text = name
        }
        guard let path = character.thumbnail?.path else {
            avatarImageView.image = UIImage(named: avatarDefault)
            return
        }
        guard let exten = character.thumbnail?.exten else {
            avatarImageView.image = UIImage(named: avatarDefault)
            return
        }
        avatarImageView.setImageFromURl(stringImageUrl: "\(path)." + "\(exten)")
    }

    func setContentForCell(element: Element) {
        favoriteButton.isHidden = true
        if let title = element.title {
            nameLabel.text = title
        }
        guard let path = element.thumbnail?.path else {
            avatarImageView.image = UIImage(named: avatarDefault)
            return
        }
        guard let exten = element.thumbnail?.exten else {
            avatarImageView.image = UIImage(named: avatarDefault)
            return
        }
        avatarImageView.setImageFromURl(stringImageUrl: "\(path)." + "\(exten)")
    }

    func setFavourited(isFavourite: Bool) {
        self.isFavorited = isFavourite
        favoriteButton?.isHidden = false
        if isFavourite {
            favoriteButton?.setBackgroundImage(UIImage.init(named: iconHeartFilledWhite), for: .normal)
        } else {
            favoriteButton?.setBackgroundImage(UIImage(named: iconHeartWhite), for: .normal)
        }
    }

    func setContentFavoriteForCell(character: Character) {
        self.character = character
        setFavourited(isFavourite: true)
        if let name = character.name {
            nameLabel.text = name
        }
        guard let avatarUrl = character.avatarUrl else {
            avatarImageView.image = UIImage(named: avatarDefault)
            return
        }
        avatarImageView.setImageFromURl(stringImageUrl: avatarUrl)
    }

    @IBAction func favoritePressed(_ sender: Any) {
        if let characterObject = self.character {
            if let indexPath = self.indexPath {
                self.onCompletionFavorite?(characterObject, self.isFavorited, indexPath)
            }
        }
    }
}
