//
//  MarvelCharacterComicView.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 15/12/2022.
//

import UIKit

class MarvelCharacterComicView: UICollectionViewCell {

    private enum Constants {

        static let fadeTimeInterval: TimeInterval = 0.5
        static let imageViewHeight: CGFloat = 250
    }

    var viewModel: MarvelCharacterComicViewModel?
    let stackView: UIStackView = UIStackView()
    let imageView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let descriptionLabel: UILabel = UILabel()

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.prepareSubviews()
        self.addConstraints()
    }

    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {

        self.resetCell()
    }

    func prepareSubviews() {

        self.stackView.frame = self.frame
        self.stackView.distribution = .fill
        self.stackView.axis = .vertical

        self.imageView.frame = CGRectMake(0, 0, self.frame.width, Constants.imageViewHeight)
        self.imageView.clipsToBounds = true

        self.imageView.contentMode = .scaleAspectFill
        self.titleLabel.numberOfLines = 2
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.titleLabel.textAlignment = .left

        self.descriptionLabel.numberOfLines = 3
        self.descriptionLabel.lineBreakMode = .byWordWrapping
        self.descriptionLabel.textAlignment = .left
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)

        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.imageView)
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.descriptionLabel)
    }

    func addConstraints() {

        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            self.imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewHeight)
        ])
    }

    func setup(viewModel: MarvelCharacterComicViewModel) {

        self.viewModel = viewModel

        self.titleLabel.text = viewModel.comic.title
        self.descriptionLabel.text = viewModel.comic.description

        self.imageView.alpha = 0

        ImageDownloader.shared.downloadImage(with: self.viewModel?.comic.thumbnail.absoluteUrl, completionHandler: { comicThumbnailImage, cached in

            DispatchQueue.main.async {

                UIView.animate(withDuration: Constants.fadeTimeInterval, animations: {

                    self.imageView.image = comicThumbnailImage
                    self.imageView.alpha = 1
                })
            }
        }, placeholderImage: nil)
    }

    func resetCell() {

        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
        self.imageView.image = nil
    }
}
