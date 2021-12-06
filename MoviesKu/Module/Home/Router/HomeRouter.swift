//
//  HomeRouter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import UIKit

class HomeRouter {
    
    private let storyboard: UIStoryboard
    
    init() {
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
    
    func makeDetail(id: Int?, navigationController: UINavigationController?) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.id = id
        detailVC.detailPresenter = DetailPresenter(detailUseCase: Injection.init().provideDetail())
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func searchMovie(title: String?, navigationController: UINavigationController?) {
        guard let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        searchVC.searchTitle = title
        searchVC.searchPresenter = SearchPresenter(searchPresenter: Injection.init().provideSearch())
        navigationController?.pushViewController(searchVC, animated: true)
    }
}


