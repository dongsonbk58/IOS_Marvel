//
//  Character.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import ObjectMapper

class Character: Mappable {

    var characterId: Int?
    var name: String?
    var description: String?
    var path: String?
    var modified: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        characterId <- map["id"]
        name <- map["name"]
        description <- map["description"]
        path <- map["thumbnail"]["path"]
        modified <- map["modified"]
    }
}
