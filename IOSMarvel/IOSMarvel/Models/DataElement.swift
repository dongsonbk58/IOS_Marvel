//
//  DataElement.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/10/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import ObjectMapper

class DataElementResponse: Mappable {
    var count: Int?
    var elements = [Element]()

    required init(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        count <- map["count"]
        elements <- map["results"]
    }
}
