//
//  CharacterResponse.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import ObjectMapper

class CharacterResponse: Mappable {
    var data: DataResponse?
    var code: Int?

    required init(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
    }
}
