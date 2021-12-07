//
//  SearchPresenter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 04/12/21.
//

import Foundation
import Combine

class SearchPresenter {
    private let searchPresenter: SearchUseCase

    init(searchPresenter: SearchUseCase) {
        self.searchPresenter = searchPresenter
    }
    
    func searchMovie(name: String) -> AnyPublisher<[MovieModel], Error> {
        return searchPresenter.searchMovie(name: name)
    }
}

