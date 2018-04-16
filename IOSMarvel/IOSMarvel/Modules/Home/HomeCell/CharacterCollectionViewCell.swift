//
//  CharacterCollectionViewCell.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

protocol CharacterCollectionViewCellDelegate: NSObjectProtocol {
    func favoritePressed(character: Character)
}

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    weak var delegate: CharacterCollectionViewCellDelegate?
    var character: Character?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentForCell(character: Character) {
        self.character = character
        favoriteButton.isHidden = false
        if let path = character.thumbnail?.path {
            if let exten = character.thumbnail?.exten {
                avatarImageView.setImageFromURl(stringImageUrl: "\(path)." + "\(exten)")
            }
        }
        if let name = character.name {
            nameLabel.text = name
        }
    }

    func setContentForCell(element: Element) {
        favoriteButton.isHidden = true
        if let path = element.thumbnail?.path {
            if let exten = element.thumbnail?.exten {
                avatarImageView.setImageFromURl(stringImageUrl: "\(path)." + "\(exten)")
            }
        }
        if let title = element.title {
            nameLabel.text = title
        }
    }

    @IBAction func favoritePressed(_ sender: Any) {
        if let characterObject = self.character {
            self.delegate?.favoritePressed(character: characterObject)
        }
    }
}
