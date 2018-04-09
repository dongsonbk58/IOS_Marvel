//
//  CharacterCollectionViewCell.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentForCell(character: Character) {
        if let path = character.thumbnail?.path {
            if let exten = character.thumbnail?.exten {
                avatarImageView.setImageFromURl(stringImageUrl: "\(path)." + "\(exten)")
            }
        }
        if character.name != nil {
            nameLbl.text = character.name
        }
    }

    @IBAction func favoritePressed(_ sender: Any) {

    }
}
