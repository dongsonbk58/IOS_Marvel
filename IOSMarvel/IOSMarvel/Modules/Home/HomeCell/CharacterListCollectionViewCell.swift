//
//  CharacterListCollectionViewCell.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

protocol CharacterListCollectionViewCellDelegate: NSObjectProtocol {
    func favoritePressed(character: Character)
}

class CharacterListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageVIew: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: CharacterListCollectionViewCellDelegate?
    var character: Character?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentForCell(character: Character) {
        self.character = character
        if let path = character.thumbnail?.path {
            if let exten = character.thumbnail?.exten {
                avatarImageVIew.setImageFromURl(stringImageUrl: "\(path)." + "\(exten)")
            }
        }
        if let name = character.name {
            nameLabel.text = name
        }
        if let description = character.description {
            descriptionLabel.text = description
        }
    }

    @IBAction func favoritePressed(_ sender: Any) {
        if let characterObject = self.character {
            self.delegate?.favoritePressed(character: characterObject)
        }
    }
}
