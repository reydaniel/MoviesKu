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
    private var errorMessage: String = ""
    private var loadingState: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var favorite: [MovieModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getFavorite()
        
        favoriteTableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteViewCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
