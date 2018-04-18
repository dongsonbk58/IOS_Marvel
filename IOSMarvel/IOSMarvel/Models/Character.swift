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
    var thumbnail: Thumbnail?
    var modified: String?
    var avatarUrl: String?
    var isFavorited: Bool?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        characterId <- map["id"]
        name <- map["name"]
        description <- map["description"]
        thumbnail <- map["thumbnail"]
        modified <- map["modified"]
    }

    init (characterId: String, name: String?, description: String, modified: String, avatarUrl: String) {
        self.characterId = Int(characterId)
        self.name = name
        self.description = description
        self.modified = modified
        self.avatarUrl = avatarUrl
    }
}
