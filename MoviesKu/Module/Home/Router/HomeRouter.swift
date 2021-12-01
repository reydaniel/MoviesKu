//
//  HomeRouter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import Foundation
import UIKit

class HomeRouter {
    func makeDetail(id: Int) -> DetailPresenter {
        let detailUseCase = Injection.init().provideDetail(by: id)
        let presenter = DetailPresenter(detailUseCase: detailUseCase)
        print("terpanggil")
        return presenter
    }
}


