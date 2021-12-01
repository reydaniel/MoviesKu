//
//  ViewController.swift
//  MoviesKu
//
//  Created by ReyDaniel on 18/11/21.
//

import UIKit
import Combine
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var nowPlayingCell: UICollectionView!
    @IBOutlet weak var popularTableView: UITableView!
    
    var presenter: HomePresenter?
    var router = HomeRouter()
    private var errorMessage: String = ""
    private var loadingState: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var nowPlaying: [MovieModel] = []
    private var popular: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        getNowPlaying()
        
        nowPlayingCell.dataSource = self
        nowPlayingCell.delegate = self
        
        popularTableView.delegate = self
        popularTableView.dataSource = self
        
        nowPlayingCell.register(UINib(nibName: "NowPlayingViewCell", bundle: nil), forCellWithReuseIdentifier: "NowPlayingViewCell")
        nowPlayingCell.reloadData()
        
        popularTableView.register(UINib(nibName: "PopularViewCell", bundle: nil), forCellReuseIdentifier: "PopularViewCell")
        popularTableView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlaying.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingViewCell", for: indexPath) as? NowPlayingViewCell {
            let item = nowPlaying[indexPath.item]
            cell.movieTitle.text = item.title
            cell.moviePoster.sd_setImage(with: URL(string: Endpoints.Gets.getImageURL(url: item.image).url))
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = nowPlaying[indexPath.item].id
        router.makeDetail(id: id, navigationController: navigationController)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "homeToDetail" {
//            let destination = segue.destination as? DetailViewController
//            let row = (sender as! NSIndexPath).row
//            destination?.id = nowPlaying[row].id
//        }
//    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popular.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = popularTableView.dequeueReusableCell(withIdentifier: "PopularViewCell") as? PopularViewCell {
            let index = popular[indexPath.row]
            cell.moviePoster.sd_setImage(with: URL(string: Endpoints.Gets.getImageURL(url: index.image).url))
            cell.movieTitle.text = index.title
            cell.movieRate.text = String(index.average)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController {
    private func getMovies() {
        loadingState = true
        presenter?.getMovies()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.loadingState = false
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
        loadingState = true
        presenter?.getNowPlaying()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.loadingState = false
                }
            }, receiveValue: { movies in
                self.nowPlaying = movies
                DispatchQueue.main.async {
                    self.nowPlayingCell.reloadData()
                }
            })
            .store(in: &cancellables)
    }
}

