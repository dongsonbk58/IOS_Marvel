//
//  ElementRepository.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/10/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ElementRepository {
    func getListElement(characterID: Int, page: Int,
                        elementType: Int, completion: @escaping (BaseResult<ElementResponse>) -> Void)
}

class ElementImplement: ElementRepository {
    private var api: APIService?

    required init(api: APIService) {
        self.api = api
    }

    func getListElement(characterID: Int, page: Int,
                        elementType: Int, completion: @escaping (BaseResult<ElementResponse>) -> Void) {
         let body: [String: Any]  = [
         "apikey": apiKey,
         "limit": limit,
         "offset": page * offset,
         "hash": hash,
         "ts": tsInt
         ]
        var url = URLs.APIGetListElementOfCharacterURL + "\(characterID)"
        switch elementType {
        case 0:
            url += "/comics"
        case 1:
            url += "/events"
        case 2:
            url += "/series"
        case 3:
            url += "/stories"
        default:
            url += "/comics"
        }
        let input = BaseRequest(url: url, requestType: .get, body: body)
        api?.request(input: input) { (object: ElementResponse?, error) in
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
