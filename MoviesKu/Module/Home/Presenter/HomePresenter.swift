//
//  HomePresenter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 22/11/21.
//

import Foundation
import Combine

class HomePresenter {
    private var cancellables: Set<AnyCancellable> = []
    private let homeUseCase: HomeUseCase
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    func getMovies() -> AnyPublisher<[MovieModel], Error> {
        return homeUseCase.getMovies()
    }
    
}
