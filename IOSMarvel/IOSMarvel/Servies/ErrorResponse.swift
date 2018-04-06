//
//  ErrorResponse.swift
//  Structure_IOS
//
//  Created by DaoLQ on 10/22/17.
//  Copyright © 2017 DaoLQ. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorResponse: Mappable {
    var code: String?
    var message: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
