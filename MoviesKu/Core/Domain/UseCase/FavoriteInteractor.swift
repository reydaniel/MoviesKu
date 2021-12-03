//
//  FavoriteInteractor.swift
//  MoviesKu
//
//  Created by ReyDaniel on 02/12/21.
//

import Foundation
import Combine

protocol FavoriteUseCase {
    func getFavorite() -> AnyPublisher<[MovieModel], Error>
}

class FavoriteInteractor: FavoriteUseCase {
    private let repository: MoviesRepositoryProtocol
    
    required init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func getFavorite() -> AnyPublisher<[MovieModel], Error> {
        return repository.getFavorite()
    }
    
}
