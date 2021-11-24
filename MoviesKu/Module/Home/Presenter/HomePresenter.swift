//
//  HomePresenter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 22/11/21.
//

import Foundation
import Combine

class HomePresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    //private let router = HomeRouter()
    private let homeUseCase: HomeUseCase
    private var movie: [MovieModel] = []
    private var errorMessage: String = ""
    private var loadingState: Bool = false
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    func getMovies() {
        loadingState = true
        homeUseCase.getMovies()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.loadingState = false
                }
            }, receiveValue: { movies in
                self.movie = movies
            })
            .store(in: &cancellables)
    }
    
}
