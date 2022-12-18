//
//  Comics.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 14/12/2022.
//

import Foundation

struct Comics: Decodable {

    let id: Int
    let title: String
    let description: String?
    let dates: [ComicDate]
    let thumbnail: ImageThumbnail
}

struct ComicDate: Decodable {

    let type: String
    let date: String
}
