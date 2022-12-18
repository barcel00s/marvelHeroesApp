//
//  ViewController.swift
//  marvelHeroesTestApp
//
//  Created by Rui Cardoso on 09/12/2022.
//

import UIKit

class MarvelCharactersTableViewController: UITableViewController, MarvelCharactersTableViewDatasourceDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    //MARK: Constants
    private enum Constants {

        static let pagingContentThreshold: CGFloat = 80
    }

    //MARK: Properties
    let serviceLayer: DataServiceLayer
    let datasource: MarvelCharactersTableViewDatasource
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var isSearchBarEmpty: Bool {

        return self.navigationItem.searchController?.searchBar.text?.isEmpty ?? true
    }

    //MARK: Initializers
    init(style: UITableView.Style, serviceLayer: DataServiceLayer) {

        self.serviceLayer = serviceLayer
        self.datasource = MarvelCharactersTableViewDatasource(serviceLayer: self.serviceLayer)

        super.init(style: style)

        self.title = "Marvel Heroes"

        self.datasource.delegate = self
    }

    convenience init(serviceLayer: DataServiceLayer) {

        self.init(style: .plain, serviceLayer: serviceLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: View Lifecycle
    override func viewDidLoad() {

        super.viewDidLoad()

        self.prepareSubViews()

        self.datasource.requestCharacters(forPage: 0)
    }

    func prepareSubViews() {

        //Register cell
        self.tableView.register(MarvelCharactersTableViewCell.self, forCellReuseIdentifier: MarvelCharactersTableViewCell.description())

        //Refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl

        //Search results controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "What's your favorite hero?"

        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true

        //ActivityIndicatorView
        activityIndicator.hidesWhenStopped = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isSearchBarEmpty {

            return datasource.marvelCharacters.count
        }
        else {

            return datasource.searchResults.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: MarvelCharactersTableViewCell.description(), for: indexPath) as! MarvelCharactersTableViewCell

        if isSearchBarEmpty {

            if self.datasource.marvelCharacters.count > indexPath.row {

                let character = self.datasource.marvelCharacters[indexPath.row]
                let viewModel = MarvelCharactersTableViewCellViewModel(character: character)

                cell.setup(viewModel: viewModel)
            }
        }
        else {

            if self.datasource.searchResults.count > indexPath.row {

                let character = self.datasource.searchResults[indexPath.row]
                let viewModel = MarvelCharactersTableViewCellViewModel(character: character)

                cell.setup(viewModel: viewModel)
            }

        }

        return cell
    }

    @objc func reloadData() {

        self.tableView.refreshControl?.beginRefreshing()
        self.datasource.requestCharacters(forPage: 0)
    }
}

//MARK: TableView Delegate
extension MarvelCharactersTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if isSearchBarEmpty {

            let character = self.datasource.marvelCharacters[indexPath.row]
            let viewController = MarvelCharacterDetailViewController(character: character, serviceLayer: self.serviceLayer)

            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {

            let character = self.datasource.searchResults[indexPath.row]
            let viewController = MarvelCharacterDetailViewController(character: character, serviceLayer: self.serviceLayer)

            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height-Constants.pagingContentThreshold) && self.datasource.requestState == .idle {

            if isSearchBarEmpty {

                //Scrolling without search
                self.datasource.requestCharacters(forPage: self.datasource.currentListingPage + 1)
            }
            else {
                //Scrolling through search results
                self.datasource.requestCharacters(forPage: self.datasource.currentSearchListingPage + 1)

            }

            self.activityIndicator.startAnimating()
        }
    }
}

//MARK: Datasrouce Delegate
extension MarvelCharactersTableViewController {

    //Datasouce delegate
    func didRetrieveCharactersList(charactersList: [Character]) {

        DispatchQueue.main.async { [weak self] in

            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
            self?.activityIndicator.stopAnimating()
        }
    }

    func didRetrieveCharacter(character: Character) {
        //Don't do anything
    }

    func didRetrieveCharacterComics(comics: [Comics]) {
        //Don't do anything
    }

    func errorRetrievingData(error: String) {

        DispatchQueue.main.async { [weak self] in

            self?.tableView.refreshControl?.endRefreshing()
            self?.activityIndicator.stopAnimating()

            let alertView = UIAlertController(title: "Error loading data", message: error, preferredStyle:
                    .alert)
            alertView.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel))

            self?.present(alertView, animated: true)
        }
    }
}

//MARK: Search results updater Delegate
extension MarvelCharactersTableViewController {

    func updateSearchResults(for searchController: UISearchController) {

        if let searchText = searchController.searchBar.text {

            if searchText.count > 0 {
                
                self.datasource.searchCharacters(withName: searchText, for: 0)
                self.activityIndicator.startAnimating()
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count == 0 {

            self.tableView.reloadData()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

        self.tableView.reloadData()

        if self.datasource.marvelCharacters.count > 0 {

            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
