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
    func getListCharacter(limit: Int, completion: @escaping (BaseResult<CharacterResponse>) -> Void)
}

class CharacterImplement: CharacterRepository {
    private var api: APIService?

    required init(api: APIService) {
        self.api = api
    }

    func getListCharacter(limit: Int, completion: @escaping (BaseResult<CharacterResponse>) -> Void) {
        let body: [String: Any]  = [
            "apikey": apiKey,
            "limit": limit,
            "hash": hash,
            "ts": tsInt
        ]

        let input = BaseRequest(url: URLs.APIGetListCharacterURL, requestType: .get, body: body)
        api?.request(input: input) { (object: CharacterResponse?, error) in
            if let obj = object {
                completion(.success(obj))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }

}
