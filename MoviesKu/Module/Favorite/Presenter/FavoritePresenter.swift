//
//  FavoritePresenter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 02/12/21.
//

import Foundation
import Combine

class FavoritePresenter {
    private let favUseCase: FavoriteUseCase

    init(favUseCase: FavoriteUseCase) {
        self.favUseCase = favUseCase
    }
    func getFavorite() -> AnyPublisher<[MovieModel], Error> {
        return favUseCase.getFavorite()
    }
}
