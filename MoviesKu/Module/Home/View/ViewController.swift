//
//  ViewController.swift
//  MoviesKu
//
//  Created by ReyDaniel on 18/11/21.
//

import UIKit
import Combine
import SDWebImage
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet weak var nowPlayingCell: UICollectionView!
    @IBOutlet weak var popularTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: HomePresenter?
    private let router = HomeRouter()
    private var errorMessage: String = ""
    private var cancellables: Set<AnyCancellable> = []
    private var nowPlaying: [MovieModel] = []
    private var popular: [MovieModel] = []
    private let loadingState = LoadingState()
    
    var searchTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMovies()
        getNowPlaying()
                        
        registerCollectionView()
        registerTableView()
        
        searchBar.delegate = self
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func registerCollectionView() {
        nowPlayingCell.dataSource = self
        nowPlayingCell.delegate = self
        
        nowPlayingCell.register(UINib(nibName: "NowPlayingViewCell", bundle: nil), forCellWithReuseIdentifier: "NowPlayingViewCell")
        nowPlayingCell.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlaying.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingViewCell", for: indexPath) as? NowPlayingViewCell {
            let item = nowPlaying[indexPath.item]
            cell.movieTitle.text = item.title
            cell.moviePoster.sd_setImage(with: URL(string: Endpoints.Gets.getImageURL(url: item.image).url))
            cell.moviePoster.setCornerRadius(image: cell.moviePoster, radius: 8)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = nowPlaying[indexPath.item].id
        router.makeDetail(id: id, navigationController: navigationController)
        tabBarController?.tabBar.isHidden = true
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func registerTableView() {
        popularTableView.delegate = self
        popularTableView.dataSource = self
        
        popularTableView.register(UINib(nibName: "PopularViewCell", bundle: nil), forCellReuseIdentifier: "PopularViewCell")
        popularTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popular.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = popularTableView.dequeueReusableCell(withIdentifier: "PopularViewCell") as? PopularViewCell {
            let index = popular[indexPath.row]
            cell.moviePoster.sd_setImage(with: URL(string: Endpoints.Gets.getImageURL(url: index.image).url))
            cell.moviePoster.setCornerRadius(image: cell.moviePoster, radius: 8)
            cell.movieTitle.text = index.title
            cell.movieRate.text = String(index.average)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = popular[indexPath.row].id
        router.makeDetail(id: id, navigationController: navigationController)
        tabBarController?.tabBar.isHidden = true
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!.replacingOccurrences(of: " ", with: "%20")
        router.searchMovie(title: query, navigationController: navigationController)
        searchBar.endEditing(true)
        searchBar.text?.removeAll()
        tabBarController?.tabBar.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.endEditing(true)
    }
}

extension ViewController {
    private func getMovies() {
        presenter?.getMovies()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                    self.loading()
                case .finished:
                    return
                }
            }, receiveValue: { movies in
                self.popular = movies
                DispatchQueue.main.async {
                    self.popularTableView.reloadData()
                }
            })
            .store(in: &cancellables)
    }
    
    private func getNowPlaying() {
        presenter?.getNowPlaying()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    return
                }
            }, receiveValue: { movies in
                self.nowPlaying = movies
                DispatchQueue.main.async {
                    self.nowPlayingCell.reloadData()
                }
            })
            .store(in: &cancellables)
    }
    
    func loading() {
        let alert = UIAlertController(title: "Loading", message: "Fetch data for the first time. Please wait...", preferredStyle: .alert)
        loadingState.loading(alert: alert)
        present(alert, animated: true, completion: nil)
    }
}

