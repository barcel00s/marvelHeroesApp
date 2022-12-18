//
//  MarvelCharactersTableViewDatasource.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 11/12/2022.
//

import Foundation

protocol MarvelCharactersTableViewDatasourceDelegate: AnyObject  {

    func didRetrieveCharactersList(charactersList: [Character])
    func didRetrieveCharacter(character: Character)
    func didRetrieveCharacterComics(comics: [Comics])

    func errorRetrievingData(error: String)
}

final class MarvelCharactersTableViewDatasource {
    
    let serviceLayer: DataServiceLayer

    var marvelCharacters: [Character] = []
    var searchResults: [Character] = []

    var selectedCharacter: Character?
    
    var currentListingPage: Int = 0
    var currentSearchListingPage: Int = 0
    var isLastPage: Bool = false
    var isLastSearchPage: Bool = false

    var requestState: NetworkRequestState = .idle

    weak var delegate: MarvelCharactersTableViewDatasourceDelegate?

    init(serviceLayer: DataServiceLayer) {

        self.serviceLayer = serviceLayer
    }

    func requestCharacters(forPage page: Int) {

        //Only ask for pages that have not yet been asked for
        if (page > currentListingPage || marvelCharacters.isEmpty) && isLastPage == false {

            self.requestState = .fetching
            self.serviceLayer.requestCharactersList(page: page) { result in

                if page == 0 {

                    self.marvelCharacters.removeAll()
                }

                self.requestState = .idle

                switch result {

                case .success(let characterContainer):

                    let charactersList = characterContainer.data.results
                    self.marvelCharacters+=charactersList
                    self.currentListingPage = page

                    if self.marvelCharacters.count == characterContainer.data.total {
                        self.isLastPage = true
                    }

                    self.delegate?.didRetrieveCharactersList(charactersList: charactersList)

                case .failure(let networkError):

                    switch networkError {

                    case .badInput, .invalidURL, .noData:

                        self.delegate?.errorRetrievingData(error: "There is a problem with the request URL")

                    case .requestError(let errorString):

                        self.delegate?.errorRetrievingData(error: errorString)
                    }
                }
            }
        }
        else {
            //Retrieve the current characters
            self.delegate?.didRetrieveCharactersList(charactersList: self.marvelCharacters)
        }
    }

    func requestCharacter(withId id: Int) {

        self.requestState = .fetching
        
        self.serviceLayer.requestCharacter(id: id) { result in

            self.requestState = .idle

            switch result {

            case .success(let characterContainer):

                if let characterInfo = characterContainer.data.results.first {

                    self.selectedCharacter = characterInfo
                    self.delegate?.didRetrieveCharacter(character: characterInfo)
                }
                else {

                    self.delegate?.errorRetrievingData(error: "Error retrieving character information")
                }

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

    func searchCharacters(withName value: String, for page: Int) {

        self.requestState = .fetching
        self.serviceLayer.searchCharacters(by: .nameStartsWith, value: value, for: page) { result in

            if page == 0 {

                self.searchResults.removeAll()
            }

            self.requestState = .idle

            switch result {
            case .success(let characterContainer):

                let charactersList = characterContainer.data.results
                self.searchResults+=charactersList

                self.currentSearchListingPage = page

                if self.searchResults.count == characterContainer.data.total {
                    self.isLastSearchPage = true
                }

                self.delegate?.didRetrieveCharactersList(charactersList: charactersList)

            case .failure(let networkError):

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
