//
//  FavoriteViewController.swift
//  MoviesKu
//
//  Created by ReyDaniel on 25/11/21.
//

import UIKit
import Combine

class FavoriteViewController: UITableViewController {
    @IBOutlet var favoriteTableView: UITableView!
    
    
    var presenter: FavoritePresenter?
    private let router = FavoriteRouter()
    private var errorMessage: String = ""
    private var loadingState: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var favorite: [MovieModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        favoriteTableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavorite()
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favorite.isEmpty {
            EmptyTableView.init().showEmptyText(tableView: tableView)
        } else {
            tableView.backgroundView = nil
        }
        return favorite.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "FavoriteViewCell") as? FavoriteCell {
            let index = favorite[indexPath.row]
            cell.moviePoster.sd_setImage(with: URL(string: Endpoints.Gets.getImageURL(url: index.image).url))
            cell.movieTitle.text = index.title
            cell.movieRating.text = String(index.average)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = favorite[indexPath.row].id
        router.makeDetail(id: id, navigationController: navigationController)
        tabBarController?.tabBar.isHidden = true
    }

}

extension FavoriteViewController {
    private func getFavorite() {
        loadingState = true
        presenter?.getFavorite()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                    print(self.errorMessage)
                case .finished:
                    self.loadingState = false
                }
            }, receiveValue: { movies in
                self.favorite = movies
                DispatchQueue.main.async {
                    self.favoriteTableView.reloadData()
                }
            })
            .store(in: &cancellables)
    }
}
