//
//  HomeRouter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import Foundation
import UIKit

class HomeRouter {
//    private let storyboard: UIStoryboard
//
//    required init() {
//        self.storyboard = UIStoryboard(name: "DetailViewController", bundle: nil)
//    }
    
    func makeDetail() -> UIViewController {
        let storyboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        guard let detailVC = storyboard.instantiateInitialViewController() as? DetailViewController else {
            return UIViewController()
        }
        detailVC.detailPresenter = DetailPresenter(detailUseCase: Injection.init().provideDetail())
        return detailVC
    }
}


