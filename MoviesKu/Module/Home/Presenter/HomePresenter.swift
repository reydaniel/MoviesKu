//
//  HomePresenter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 22/11/21.
//

import Foundation
import Combine

class HomePresenter {
    private let homeUseCase: HomeUseCase
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    func getNowPlaying() -> AnyPublisher<[MovieModel], Error> {
        return homeUseCase.getNowPlaying()
    }
    
    func getMovies() -> AnyPublisher<[MovieModel], Error> {
        return homeUseCase.getMovies()
    }
    
}
