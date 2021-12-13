//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var goSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var movies: [Movie] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMovies: [Movie] = []
    var imageBaseURL = ""

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && (!isSearchBarEmpty)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: to figure out how to do add default movie list
        movies = []
        // To fetch base url before will help us load image view
        fetchConfiguration()

        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 88))
        navBar.backgroundColor = .systemBlue
        view.addSubview(navBar)

        searchBar.barStyle = .default
        searchBar.tintColor = .systemBlue
        searchBar.placeholder = "Search Movies"
        searchBar.isTranslucent = false
        searchBar.delegate = self

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ShowDetailSegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? MovieDetailViewController
        else {
            return
        }

        let movie: Movie
        if isFiltering {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        detailViewController.baseURL = self.imageBaseURL
        detailViewController.movie = movie
    }

    @IBAction func searchForText(_ sender: Any) {
        // Helps to reset between searches
        resetSearchList()

        Network().fetchSearchesFromAPI(searchString: searchBar.text!) { (result) in
            switch result {
            case .success(let data):
                guard let result = data else {
                    return
                }
                result.results.forEach { movie in
                    self.movies.append(movie)
                }
                DispatchQueue.main.async {
                    self.filterContentForSearchText(self.searchBar.text!)
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredMovies = movies.filter { (movie: Movie) -> Bool in
            return movie.title.lowercased().contains(searchText.lowercased())
        }

        tableView.reloadData()
    }

    func resetSearchList() {
        movies = []
        tableView.reloadData()
    }

    func fetchConfiguration() {
        Network().fetchBaseURL { (result) in
            switch result {
            case .success(let data):
                guard let result = data else {
                    return
                }
                self.imageBaseURL = result.images.base_url
                print(result.images.base_url)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            view.layoutIfNeeded()
            return
        }

        guard
            let info = notification.userInfo,
            let _ = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredMovies.count
        }
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieTableViewCell
        let movie: Movie
        if isFiltering {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        cell.movieTitle.text = movie.title
        cell.movieDate.text = movie.release_date
        cell.movieRating.text = "\(movie.vote_average)"
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    // if we want to search while typing enable this
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
//        Network().fetchSearchesFromAPI(searchString: searchBar.text!) { (result) in
//            switch result {
//            case .success(let data):
//                guard let result = data else {
//                    return
//                }
//                result.results.forEach { movie in
//                    self.movies.append(movie)
//                }
//                DispatchQueue.main.async {
//                    self.filterContentForSearchText(searchBar.text!)
//                }
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}
