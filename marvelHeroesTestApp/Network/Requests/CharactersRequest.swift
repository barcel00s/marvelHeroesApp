//
//  CharactersRequest.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 09/12/2022.
//

import Foundation

private enum Constants {

    static let charactersListURL: String = "characters"
    static let comicsListURL: String = "comics"
    static let characterListPageSize: Int = 20
    static let comicsListLimit: Int = 50
}

enum CharactersRequest: Request {

    case all(page: Int)
    case individual(id: Int)
    case comics(id: Int)
    case search(criteria: CharacterSearchCriteria, value: String, page: Int)

    var path: String {

        switch self {

        case .all, .search:

            return Constants.charactersListURL

        case .individual(let id):

            return Constants.charactersListURL + "/\(id)"

        case .comics(let id):

            return Constants.charactersListURL + "/\(id)/\(Constants.comicsListURL)"
        }
    }

    var method: HTTPMethod {

        return .get
    }

    var parameters: RequestParams? {

        switch self {

        case .all(let page):

            if page > 0 {
                
                return RequestParams.url(["offset": "\(page * Constants.characterListPageSize)","limit":"\(Constants.characterListPageSize)"])
            }
            else {

                return nil
            }

        case .individual(_):

            return nil

        case .search(let criteria, let value, let page):

            if page > 0 {

                return RequestParams.url(["offset": "\(page * Constants.characterListPageSize)","limit":"\(Constants.characterListPageSize)"])
            }
            
            return RequestParams.url([criteria.rawValue: value])

        case .comics(_):

            return RequestParams.url(["limit": "\(Constants.comicsListLimit)"])
        }
    }

    var headers: [String : String]? {

        return nil
    }
}
