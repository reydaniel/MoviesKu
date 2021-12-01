//
//  HomeRouter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import Foundation
import UIKit

class HomeRouter {
    func makeDetail(id: Int?, navigationController: UINavigationController?) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.id = id
        detailVC.detailPresenter = DetailPresenter(detailUseCase: Injection.init().provideDetail())
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


