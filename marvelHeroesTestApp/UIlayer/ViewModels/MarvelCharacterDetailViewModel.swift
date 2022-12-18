//
//  MarvelCharacterDetailViewModel.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 12/12/2022.
//

import UIKit

struct MarvelCharacterDetailViewModel {

    let character: Character
    var comics: [Comics] = []

    weak var collectionViewDatasource: UICollectionViewDataSource?
    weak var collectionViewDelegate: UICollectionViewDelegate?
}
