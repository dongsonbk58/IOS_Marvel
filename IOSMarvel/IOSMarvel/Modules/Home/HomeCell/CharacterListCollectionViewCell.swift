//
//  CharacterListCollectionViewCell.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

class CharacterListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageVIew: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentForCell(character: Character) {
        if let path = character.thumbnail?.path {
            if let exten = character.thumbnail?.exten {
                avatarImageVIew.setImageFromURl(stringImageUrl: "\(path)." + "\(exten)")
            }
        }
        if character.name != nil {
            nameLbl.text = character.name
        }
        if character.description != nil {
            descriptionLbl.text = character.description
        }
    }

    @IBAction func favoritePressed(_ sender: Any) {

    }
}
