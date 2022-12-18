//
//  MarvelCharacterDetailView.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 12/12/2022.
//

import UIKit

class MarvelCharacterDetailView: UIView {

    private let viewModel: MarvelCharacterDetailViewModel
    private let stackView: UIStackView = UIStackView()
    private let scrollView: UIScrollView = UIScrollView()
    private let comicsCollectionView: UICollectionView = {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = Constants.comicsCollectionViewCellSize
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = Constants.comicsCollectionViewCellSpacing

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.register(MarvelCharacterComicView.self, forCellWithReuseIdentifier: MarvelCharacterComicView.self.description())

        return collectionView
    }()

    private let comicsActivityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let characterProfileImageView: UIImageView = UIImageView()
    private let characterTitleLabel: UILabel = UILabel()
    private let characterDescriptionLabel: UILabel = UILabel()


    enum Constants {
        static let characterProfileImageViewCornerRadius: CGFloat = 50
        static let characterTitleMinimumHeight: CGFloat = 60
        static let characterProfileImageViewHeight: CGFloat = 400
        static let comicsCollectionViewHeight: CGFloat = 400
        static let comicsCollectionViewCellSize: CGSize = CGSizeMake(200, 350)
        static let comicsCollectionViewCellSpacing: CGFloat = 5
        static let comicsTransitionAnimationDuration: CGFloat = 0.2
    }

    init(viewModel: MarvelCharacterDetailViewModel) {

        self.viewModel = viewModel

        super.init(frame: CGRect.zero)

        self.prepareSubviews()
        self.addConstraints()
        self.configureView(viewModel: self.viewModel)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareSubviews() {
        self.backgroundColor = .white
        self.characterProfileImageView.contentMode = .scaleAspectFill
        self.characterProfileImageView.clipsToBounds = true

        self.characterTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.characterTitleLabel.textAlignment = .center
        self.characterDescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.characterDescriptionLabel.numberOfLines = 0

        self.scrollView.contentInsetAdjustmentBehavior = .never

        self.comicsActivityIndicatorView.hidesWhenStopped = true

        self.stackView.distribution = .fill
        self.stackView.axis = .vertical

        self.addSubview(self.scrollView)

        self.scrollView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.characterProfileImageView)
        self.stackView.addArrangedSubview(self.characterTitleLabel)
        self.stackView.addArrangedSubview(self.characterDescriptionLabel)
        self.stackView.addArrangedSubview(self.comicsCollectionView)

        self.comicsCollectionView.isHidden = true
    }

    private func addConstraints() {

        //ScrollView + StackView
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.stackView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor)
        ])

        let bottomContraint = self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        bottomContraint.priority = .defaultLow
        bottomContraint.isActive = true

        //Profile ImageView + Comics CollectionView
        self.characterProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.characterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.characterDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.comicsActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.comicsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        let comicsCollectionViewHeightConstraint = self.comicsCollectionView.heightAnchor.constraint(equalToConstant: Constants.comicsCollectionViewHeight)
        comicsCollectionViewHeightConstraint.priority = UILayoutPriority(999)

        self.characterTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.characterDescriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        NSLayoutConstraint.activate([

            self.characterProfileImageView.heightAnchor.constraint(equalToConstant: Constants.characterProfileImageViewHeight),
            comicsCollectionViewHeightConstraint,
            self.characterTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.characterTitleMinimumHeight)
        ])
    }

    func configureView(viewModel: MarvelCharacterDetailViewModel) {

        DispatchQueue.main.async {
            
            self.comicsCollectionView.dataSource = viewModel.collectionViewDatasource
            self.comicsCollectionView.delegate = viewModel.collectionViewDelegate

            if viewModel.comics.count > 0 && self.comicsCollectionView.isHidden {

                UIView.animate(withDuration: Constants.comicsTransitionAnimationDuration, animations: { [weak self] in

                    self?.comicsCollectionView.isHidden = false
                    self?.stackView.layoutIfNeeded()
                })

                self.comicsCollectionView.reloadData()
            }

            ImageDownloader.shared.downloadImage(with: viewModel.character.thumbnail.absoluteUrl, completionHandler: { image, cache in

                DispatchQueue.main.async {

                    self.characterProfileImageView.image = image
                }
            }, placeholderImage: nil)

            self.characterTitleLabel.text = viewModel.character.name
            self.characterDescriptionLabel.text = viewModel.character.description
        }
    }

    func toggleActivityIndicator(for networkRequestState: NetworkRequestState) {

        switch networkRequestState {

        case .idle:
            self.comicsActivityIndicatorView.stopAnimating()

        case .fetching:
            self.comicsActivityIndicatorView.startAnimating()
            
        }
    }
}
