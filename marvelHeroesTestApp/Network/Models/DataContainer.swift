//
//  CharactersContainer.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 09/12/2022.
//

import Foundation

struct DataContainer<T: Decodable>: Decodable {

    let data: RequestData<T>
}

struct RequestData<T: Decodable>: Decodable {

    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}
