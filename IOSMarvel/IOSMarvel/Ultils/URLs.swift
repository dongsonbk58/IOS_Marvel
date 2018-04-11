//
//  URLs.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation

struct URLs {
    private static var APIBaseUrl = "https://gateway.marvel.com:443/v1/public/"

    public static let APIGetListCharacterURL = APIBaseUrl + "characters"
    public static let APIGetListElementOfCharacterURL = APIBaseUrl + "characters/"
}
