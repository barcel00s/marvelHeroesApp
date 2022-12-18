//
//  MarvelNavigationController.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 11/12/2022.
//

import UIKit

class MarvelUINavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {

        super.init(rootViewController: rootViewController)

        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.tintColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
