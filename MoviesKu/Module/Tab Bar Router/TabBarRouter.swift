//
//  TabBarRouter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 24/11/21.
//

import Foundation
import UIKit

class TabBarRouter {
    private let storyboard: UIStoryboard
    
    init() {
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
    
    func makeHomeView() -> UIViewController {
        guard let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? ViewController else {
            return UIViewController()
        }
        homeVC.presenter = HomePresenter(homeUseCase: Injection.init().provideHome())
        return homeVC
    }
    
    func makeHomeNavigation() -> UINavigationController {
        guard let homeNC = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as? HomeNavigationController else {
            return UINavigationController()
        }
        homeNC.viewControllers = [makeHomeView()]
        return homeNC
    }
    
    func makeFavoriteView() -> UIViewController {
        guard let favoriteVC = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController else {
            return UIViewController()
        }
        return favoriteVC
    }
    
    func makeFavoriteNavigation() -> UINavigationController {
        guard let favoriteNC = storyboard.instantiateViewController(withIdentifier: "FavoriteNavigationController") as? FavoriteNavigationController else {
            return UINavigationController()
        }
        favoriteNC.viewControllers = [makeFavoriteView()]
        return favoriteNC
    }
    
    func makeTabBar() -> TabBarViewController {
        guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabbar") as? TabBarViewController else {
            return TabBarViewController()
        }
        tabBarVC.viewControllers = [makeHomeNavigation(), makeFavoriteNavigation()]
        return tabBarVC
    }
    
}
