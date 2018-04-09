//
//  UIImageView.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/9/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImageFromURl(stringImageUrl url: String) {
        if let url = URL(string: url) {
            let rs = ImageResource(downloadURL: url)
            self.kf.setImage(with: rs)
        }
    }
}
