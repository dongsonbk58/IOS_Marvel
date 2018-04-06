//
//  CharactorRepository.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/6/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import ObjectMapper

protocol CharacterRepository {
    func getListCharacter(limit: Int, completion: @escaping (BaseResult<Character>) -> Void)
}

class CharacterImplement: CharacterRepository {
    private var api: APIService?

    required init(api: APIService) {
        self.api = api
    }

    func getListCharacter(limit: Int, completion: @escaping (BaseResult<Character>) -> Void) {

    }
}
