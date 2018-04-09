//
//  DataResponse.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/9/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import ObjectMapper

class DataResponse: Mappable {
    var count: Int?
    var characters = [Character]()

    required init(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        count <- map["count"]
        characters <- map["results"]
    }
}
