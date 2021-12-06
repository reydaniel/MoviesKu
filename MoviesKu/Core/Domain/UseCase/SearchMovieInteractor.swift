//
//  SearchMovieInteractor.swift
//  MoviesKu
//
//  Created by ReyDaniel on 04/12/21.
//

import Combine

protocol SearchUseCase {
    func searchMovie(name: String) -> AnyPublisher<[MovieModel], Error>
}

class SearchMovieInteractor: SearchUseCase {
    private let repository: MoviesRepositoryProtocol
    
    required init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func searchMovie(name: String) -> AnyPublisher<[MovieModel], Error> {
        return repository.searchMovie(name: name)
    }
    
}
