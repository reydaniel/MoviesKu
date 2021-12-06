//
//  DetailInteractor.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import Combine

protocol DetailUseCase {
    func getDetail(id: Int) -> AnyPublisher<DetailModel, Error>
    func addMovies(id: Int) -> AnyPublisher<Bool, Error>
    func checkID(id: Int) -> Bool
}

class DetailInteractor: DetailUseCase {
    private let repository: MoviesRepositoryProtocol
    
    required init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetail(id: Int) -> AnyPublisher<DetailModel, Error> {
        return repository.getDetail(id: id)
    }
    
    func addMovies(id: Int) -> AnyPublisher<Bool, Error> {
        return repository.addMovies(id: id)
    }
    
    func checkID(id: Int) -> Bool {
        return repository.checkID(id: id)
    }
}
