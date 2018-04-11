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
    func getListElement(characterID: Int, limit: Int, completion: @escaping (BaseResult<ElementResponse>) -> Void)
}

class ElementImplement: ElementRepository {
    private var api: APIService?

    required init(api: APIService) {
        self.api = api
    }

    func getListElement(characterID: Int, limit: Int, completion: @escaping (BaseResult<ElementResponse>) -> Void) {

    }

}
