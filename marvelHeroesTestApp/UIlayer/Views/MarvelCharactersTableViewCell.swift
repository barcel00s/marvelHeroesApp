//
//  MarvelCharactersTableViewCell.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 11/12/2022.
//

import UIKit

class MarvelCharactersTableViewCell: UITableViewCell {

    enum Constants {

        static let maximumImageSize: CGSize = CGSizeMake(100, 100)
        static let imageCornerRadius: CGFloat = 10
        static let fontSize: CGFloat = 18.0
    }

    var viewModel: MarvelCharactersTableViewCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {

        self.resetCell()
    }
}

extension MarvelCharactersTableViewCell {

    func setup(viewModel: MarvelCharactersTableViewCellViewModel) {

        self.viewModel = viewModel

        ImageDownloader.shared.downloadImage(with: self.viewModel?.character.thumbnail.absoluteUrl, completionHandler: { characterThumbnailImage, cached in

            self.setContentConfiguration(viewModel: viewModel, image: characterThumbnailImage)
        }, placeholderImage: nil)
    }

    private func setContentConfiguration(viewModel: MarvelCharactersTableViewCellViewModel, image: UIImage?) {

        var content = self.defaultContentConfiguration()
        content.text = self.viewModel?.character.name
        content.textProperties.font = UIFont.boldSystemFont(ofSize: Constants.fontSize)

        content.imageProperties.maximumSize = Constants.maximumImageSize
        content.imageProperties.reservedLayoutSize = Constants.maximumImageSize
        content.imageProperties.cornerRadius = Constants.imageCornerRadius

        content.image = image

        self.contentConfiguration = content

        self.accessoryType = .disclosureIndicator
    }

    private func resetCell() {

        self.contentConfiguration = self.defaultContentConfiguration()
    }
}
