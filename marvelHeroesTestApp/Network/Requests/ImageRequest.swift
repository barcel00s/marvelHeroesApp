//
//  ImageRequest.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 12/12/2022.
//

import Foundation

enum ImageRequest: Request {

    case thumbnail(url: String)
    case full(url: String)

    var path: String {

        switch self {

        case .thumbnail(let url):
            return url

        case .full(let url):
            return url
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
