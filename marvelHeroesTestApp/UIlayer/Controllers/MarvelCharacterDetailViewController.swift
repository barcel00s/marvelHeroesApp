//
//  MarvelCharacterDetailViewController.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 12/12/2022.
//

import UIKit

class MarvelCharacterDetailViewController: UIViewController {

    let character: Character
    let datasource: MarvelCharacterDetailDatasource
    
    init(character: Character, serviceLayer: DataServiceLayer) {

        self.character = character
        self.datasource = MarvelCharacterDetailDatasource(serviceLayer: serviceLayer)

        super.init(nibName: nil, bundle: nil)

        self.datasource.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        super.loadView()

        let viewModel = MarvelCharacterDetailViewModel(character: self.character, collectionViewDatasource: self, collectionViewDelegate: self)
        let view = MarvelCharacterDetailView(viewModel: viewModel)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getCharacterComics()
    }

    func getCharacterComics() {

        if let view = self.view as? MarvelCharacterDetailView {
            
            view.toggleActivityIndicator(for: .idle)
        }

        self.datasource.requestCharacterComics(withId: self.character.id)
    }
}

extension MarvelCharacterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        self.datasource.characterComics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelCharacterComicView.self.description(), for: indexPath) as! MarvelCharacterComicView

        let comic = datasource.characterComics[indexPath.row]
        let viewModel = MarvelCharacterComicViewModel(comic: comic)

        cell.setup(viewModel: viewModel)

        return cell
    }
}

extension MarvelCharacterDetailViewController: MarvelCharacterDetailDatasourceDelegate {

    func didRetrieveCharacterComics(comics: [Comics]) {

        DispatchQueue.main.async {

            if let view = self.view as? MarvelCharacterDetailView {

                let viewModel = MarvelCharacterDetailViewModel(character: self.character, comics: comics, collectionViewDatasource: self, collectionViewDelegate: self)
                view.configureView(viewModel: viewModel)

                view.toggleActivityIndicator(for: .idle)
            }
        }
    }

    func errorRetrievingData(error: String) {
        //TODO: Hide comics collection view with animation
    }
}
