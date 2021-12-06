//
//  SearchViewController.swift
//  MoviesKu
//
//  Created by ReyDaniel on 04/12/21.
//

import UIKit
import Combine

class SearchViewController: UITableViewController {
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let router = SearchRouter()
    private var errorMessage: String = ""
    private var loadingState: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var movieList: [MovieModel] = []
    
    var searchTitle: String?
    var searchPresenter: SearchPresenter?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        searchBar.text = searchTitle
        searchMovie()
        
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movieList.isEmpty {
            EmptyTableView.init().showEmptyText(tableView: tableView)
        } else {
            tableView.backgroundView = nil
        }
        return movieList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell {
            let index = movieList[indexPath.row]
            cell.moviePoster.sd_setImage(with: URL(string: Endpoints.Gets.getImageURL(url: index.image).url))
            cell.movieTitle.text = index.title
            cell.movieRating.text = String(index.average)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = movieList[indexPath.row].id
        router.makeDetail(id: id, navigationController: navigationController)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!.replacingOccurrences(of: " ", with: "%20")
        searchTitle = query
        searchMovie()
        searchBar.endEditing(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchMovie() {
        guard let searchTitle = searchTitle else {
            return
        }
        
        loadingState = true
        searchPresenter?.searchMovie(name: searchTitle)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                    print(self.errorMessage)
                case .finished:
                    self.loadingState = false
                }
            }, receiveValue: { list in
                self.movieList = list
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            })
            .store(in: &cancellables)
    }
}
