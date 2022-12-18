//
//  MarvelCharactersDetailDatasource.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 16/12/2022.
//

import Foundation

protocol MarvelCharacterDetailDatasourceDelegate: AnyObject  {

    func didRetrieveCharacterComics(comics: [Comics])
    func errorRetrievingData(error: String)
}

final class MarvelCharacterDetailDatasource {

    let serviceLayer: DataServiceLayer
    var characterComics: [Comics] = []
    var requestState: NetworkRequestState = .idle
    weak var delegate: MarvelCharacterDetailDatasourceDelegate?

    init(serviceLayer: DataServiceLayer) {

        self.serviceLayer = serviceLayer
    }

    func requestCharacterComics(withId id: Int) {

        self.requestState = .fetching

        self.serviceLayer.requestCharacterComics(id: id) { result in

            self.requestState = .idle

            switch result {

            case .success(let comicsContainer):

                let comicsInfo = comicsContainer.data.results
                self.characterComics = comicsInfo
                self.delegate?.didRetrieveCharacterComics(comics: comicsInfo)

            case.failure(let networkError):

                switch networkError {

                case .badInput, .invalidURL, .noData:

                    self.delegate?.errorRetrievingData(error: "There is a problem with the request URL")

                case .requestError(let errorString):

                    self.delegate?.errorRetrievingData(error: errorString)
                }
            }
        }
    }
}
