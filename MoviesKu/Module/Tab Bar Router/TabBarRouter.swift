//
//  TabBarRouter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 24/11/21.
//

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
        favoriteVC.presenter = FavoritePresenter(favUseCase: Injection.init().provideFavorite())
        return favoriteVC
    }
    
    func makeFavoriteNavigation() -> UINavigationController {
        guard let favoriteNC = storyboard.instantiateViewController(withIdentifier: "FavoriteNavigationController") as? FavoriteNavigationController else {
            return UINavigationController()
        }
        favoriteNC.viewControllers = [makeFavoriteView()]
        return favoriteNC
    }
    
    func makeProfileView() -> UIViewController {
        guard let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            return UIViewController()
        }
        return profileVC
    }
    
    func makeProfileNavigation() -> UINavigationController {
        guard let profileNC = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as? ProfileNavigationController else {
            return ProfileNavigationController()
        }
        profileNC.viewControllers = [makeProfileView()]
        return profileNC
    }
    
    func makeTabBar() -> TabBarViewController {
        guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabbar") as? TabBarViewController else {
            return TabBarViewController()
        }
        tabBarVC.viewControllers = [makeHomeNavigation(), makeFavoriteNavigation(), makeProfileNavigation()]
        return tabBarVC
    }
    
}
