//
//  ComicsRequest.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 14/12/2022.
//

import Foundation

private enum Constants {

    static let comicsListURL: String = "comics"
    static let comicsListPageSize: Int = 20
}

enum ComicsRequest: Request {

    case all
    case individual(id: Int)

    var path: String {

        switch self {

        case .all:

            return Constants.comicsListURL

        case .individual(let id):

            return Constants.comicsListURL + "/\(id)"
        }
    }

    var method: HTTPMethod {

        return .get
    }

    var parameters: RequestParams? {

        return nil
    }

    var headers: [String : String]? {

        return nil
    }


}
