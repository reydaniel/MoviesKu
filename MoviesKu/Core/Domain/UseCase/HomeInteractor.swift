//
//  HomeInteractor.swift
//  MoviesKu
//
//  Created by ReyDaniel on 22/11/21.
//

import Foundation
import Combine

protocol HomeUseCase {
    func getMovies() -> AnyPublisher<[MovieModel], Error>
}

class HomeInteractor: HomeUseCase {
    private let repository: MoviesRepositoryProtocol
    
    required init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func getMovies() -> AnyPublisher<[MovieModel], Error> {
        return repository.getMovies()
    }
}
