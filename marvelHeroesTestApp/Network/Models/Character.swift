//
//  Character.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 09/12/2022.
//

import Foundation

struct Character: Decodable {

    let id: Int
    let name: String
    let description: String
    let modified: String
    let resourceURI: String
    //let urls: [URL]
    let thumbnail: ImageThumbnail

    /*
     Comics
     Stories
     Events
     Series
     */
}
