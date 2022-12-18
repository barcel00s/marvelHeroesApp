//
//  DataServiceLayer.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 09/12/2022.
//

import Foundation

private enum Constants {

    static let marvelAPIName: String = "Marvel API"
    static let marvelBaseURL: String = "https://gateway.marvel.com/v1/public"
    static let marvelPublicAPIKey: String = "8f707dcfbcd3a349e13cdda6d0dd7240"
    static let marvelPrivateAPIKey: String = "76fbd648fca49a0987d52fd667ed1085b9a911b8"
}

final class DataServiceLayer: NetworkLayerDelegate {

    var networkConfig: NetworkAPIConfig
    let networkLayer: NetworkLayer

    init(networkConfig: NetworkAPIConfig? = nil, networkLayer: NetworkLayer? = nil) {

        if let networkConfig = networkConfig, let networkLayer = networkLayer {

            self.networkConfig = networkConfig
            self.networkLayer = networkLayer
        }
        else {

            self.networkConfig = NetworkAPIConfig(Constants.marvelAPIName, baseUrl: Constants.marvelBaseURL)
            self.networkConfig.publicAPIKey = Constants.marvelPublicAPIKey
            self.networkConfig.secret = Constants.marvelPrivateAPIKey

            self.networkLayer = NetworkLayer(networkConfig: self.networkConfig)
        }

        self.networkLayer.delegate = self
    }

    func hashGeneration(usingTimestamp timestamp: String, apikey: String, secret: String) -> String {

        return "\(timestamp)\(secret)\(apikey)".MD5()
    }
}
