//
//  Thumbnail.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/9/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import ObjectMapper

class Thumbnail: Mappable {
    var path: String?
    var exten: String?

    required init(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        path <- map["path"]
        exten <- map["extension"]
    }
}
