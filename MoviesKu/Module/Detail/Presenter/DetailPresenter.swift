//
//  DetailPresenter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import Foundation
import Combine

class DetailPresenter {
    private let detailUseCase: DetailUseCase
    var router: HomeRouter?
    
    init(detailUseCase: DetailUseCase) {
        self.detailUseCase = detailUseCase
    }
    
    func getDetail(id: Int) -> AnyPublisher<DetailModel, Error> {
        return detailUseCase.getDetail(id: id)
    }
    
    func addMovies(id: Int) -> AnyPublisher<Bool, Error> {
        return detailUseCase.addMovies(id: id)
    }
    
    func checkID(id: Int) -> Bool {
        return detailUseCase.checkID(id: id)
    }
}
