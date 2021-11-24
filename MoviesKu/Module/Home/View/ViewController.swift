//
//  ViewController.swift
//  MoviesKu
//
//  Created by ReyDaniel on 18/11/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nowPlayingCell: UICollectionView!
    
    private var movie: [MovieModel] = []
    var presenter: HomePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getMovies()
        print("list: \(movie.first)")
        
        nowPlayingCell.dataSource = self
        
        nowPlayingCell.register(UINib(nibName: "NowPlayingViewCell", bundle: nil), forCellWithReuseIdentifier: "NowPlayingViewCell")
        nowPlayingCell.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = nowPlayingCell.dequeueReusableCell(withReuseIdentifier: "NowPlayingViewCell", for: indexPath) as! NowPlayingViewCell
//        let item = movie[indexPath.item]
        cell.movieTitle.text = "Film"
        return cell
    }
    
    
}

