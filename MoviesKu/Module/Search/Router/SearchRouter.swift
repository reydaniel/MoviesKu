//
//  SearchRouter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 06/12/21.
//

import UIKit

class SearchRouter {
    func makeDetail(id: Int?, navigationController: UINavigationController?) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.id = id
        detailVC.detailPresenter = DetailPresenter(detailUseCase: Injection.init().provideDetail())
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
