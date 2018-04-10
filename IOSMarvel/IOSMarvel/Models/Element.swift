//
//  Element.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/10/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import ObjectMapper

class Element: Mappable {

    var elementId: Int?
    var title: String?
    var thumbnail: Thumbnail?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        elementId <- map["id"]
        title <- map["title"]
        thumbnail <- map["thumbnail"]
    }
}
