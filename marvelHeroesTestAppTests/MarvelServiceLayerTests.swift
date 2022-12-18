//
//  ServiceLayerTest.swift
//  marvelHeroesTestAppTests
//
//  Created by Rui Cardoso on 09/12/2022.
//

import XCTest

final class MarvelServiceLayerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try!super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try!super.tearDownWithError()
    }

    func testGetFirstPageOfMarvelCharacters() {

        let expectation = self.expectation(description: "testGetFirstPageOfMarvelCharacters")

        let marvelServiceLayer = DataServiceLayer()
        var expectedAllCharacters: [Character]?

        marvelServiceLayer.requestCharactersList(page: 0) { result in

            switch result {

            case .success(let charactersContainer):

                expectedAllCharacters = charactersContainer.data.results
            case .failure(let networkError):

                switch networkError {

                case .noData, .invalidURL, .badInput:
                    print("Error with character request input")

                case .requestError(let error):
                    print(error)

                }
            }

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 10) { error in

            XCTAssertNotNil(expectedAllCharacters)
            XCTAssertNil(error)
        }
    }

    func testGetSecondPageOfMarvelCharacters() {

        let expectation = self.expectation(description: "testGetSecondPageOfMarvelCharacters")

        let marvelServiceLayer = DataServiceLayer()
        var expectedAllCharacters: [Character]?

        marvelServiceLayer.requestCharactersList(page: 1) { result in

            switch result {

            case .success(let charactersContainer):
                expectedAllCharacters = charactersContainer.data.results

            case .failure(let networkError):

                switch networkError {

                case .noData, .invalidURL, .badInput:
                    print("Error with character request input")

                case .requestError(let error):
                    print(error)

                }
            }

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 10) { error in

            XCTAssertNotNil(expectedAllCharacters)
            XCTAssertNil(error)
        }
    }

    func testGetMarvelCharacterWithID() {

        let characterID = 1011334
        let expectation = self.expectation(description: "testGetMarvelCharacterWithID")

        let marvelServiceLayer = DataServiceLayer()
        var characterData: Character?

        marvelServiceLayer.requestCharacter(id: characterID, completion: { result in

            switch result {

            case .success(let charactersContainer):
                characterData = charactersContainer.data.results.first

            case .failure(let networkError):

                switch networkError {

                case .noData, .invalidURL, .badInput:
                    print("Error with character request input")

                case .requestError(let error):
                    print(error)

                }
            }

            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 10) { error in

            XCTAssertNotNil(characterData)
            XCTAssertNil(error)
        }
    }

    func testGetMarvelCharacterComics() {

        let characterID = 1011334
        let expectation = self.expectation(description: "testGetComicsForMarvelCharacter")

        let marvelServiceLayer = DataServiceLayer()
        var comicsData: [Comics]?

        marvelServiceLayer.requestCharacterComics(id: characterID, completion: { result in

            switch result {

            case .success(let comicsContainer):
                comicsData = comicsContainer.data.results

            case .failure(let networkError):

                switch networkError {

                case .noData, .invalidURL, .badInput:
                    print("Error with character request input")

                case .requestError(let error):
                    print(error)
                }
            }

            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 10) { error in

            XCTAssertNotNil(comicsData)
            XCTAssertNil(error)
        }
    }
}
