//
//  ImageThumbnail.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 14/12/2022.
//

import Foundation

struct ImageThumbnail: Decodable {

    let path: String
    let fileExtension: String

    var absoluteUrl: String? {

        return path + ".\(fileExtension)"
    }

    enum CodingKeys: String, CodingKey {

        case path
        case fileExtension = "extension"
    }
}
