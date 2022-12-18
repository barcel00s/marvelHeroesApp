//
//  DatasourceLayer+CharacterRequests.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 09/12/2022.
//

import Foundation

enum CharacterSearchCriteria: String {

    case name
    case nameStartsWith
}

extension DataServiceLayer {

    func requestCharactersList(page: Int, completion: @escaping (Swift.Result<DataContainer<Character>, NetworkErrors>) -> Void) {

        let request: CharactersRequest = .all(page: page)

        self.networkLayer.execute(request: request) { (response: Swift.Result<DataContainer<Character>,NetworkErrors>) in

            completion(response)
        }
    }

    func requestCharacter(id: Int, completion: @escaping (Swift.Result<DataContainer<Character>, NetworkErrors>) -> Void) {

        let request: CharactersRequest = .individual(id: id)

        self.networkLayer.execute(request: request, completion: { (response: Swift.Result<DataContainer<Character>,NetworkErrors>) in

            completion(response)
        })
    }

    func requestCharacterComics(id: Int, completion: @escaping (Swift.Result<DataContainer<Comics>, NetworkErrors>) -> Void) {

        let request: CharactersRequest = .comics(id: id)

        self.networkLayer.execute(request: request, completion: { (response: Swift.Result<DataContainer<Comics>,NetworkErrors>) in

            completion(response)
        })
    }

    func searchCharacters(by criteria: CharacterSearchCriteria, value: String, for page: Int, completion: @escaping (Swift.Result<DataContainer<Character>, NetworkErrors>) -> Void) {

        let request: CharactersRequest = .search(criteria: criteria, value: value, page: page)

        self.networkLayer.execute(request: request) { (response: Swift.Result<DataContainer<Character>,NetworkErrors>) in

            completion(response)
        }
    }
}
