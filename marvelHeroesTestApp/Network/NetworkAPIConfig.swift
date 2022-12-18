//
//  NetworkAPIConfig.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 09/12/2022.
//

import Foundation

struct NetworkAPIConfig {

    let name: String
    let baseUrl: String
    var publicAPIKey: String?
    var secret: String?
    var headers: [String: String] = [:]
    var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData

    init(_ name: String, baseUrl: String) {

        self.name = name
        self.baseUrl = baseUrl
    }
}
