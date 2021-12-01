//
//  DetailInteractor.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import Foundation
import Combine

protocol DetailUseCase {
    func getDetail(id: Int) -> AnyPublisher<DetailModel, Error>
}

class DetailInteractor: DetailUseCase {
    private let repository: MoviesRepositoryProtocol
    private let id: Int
    
    required init(by id: Int, repository: MoviesRepositoryProtocol) {
        self.id = id
        self.repository = repository
    }
    
    func getDetail(id: Int) -> AnyPublisher<DetailModel, Error> {
        return repository.getDetail(id: id)
    }
}
