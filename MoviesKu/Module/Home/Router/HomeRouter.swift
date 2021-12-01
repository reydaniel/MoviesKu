//
//  HomeRouter.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import Foundation
import UIKit

class HomeRouter {
    func makeDetail() -> DetailPresenter {
        let detailUseCase = Injection.init().provideDetail()
        let presenter = DetailPresenter(detailUseCase: detailUseCase)
        
        return presenter
    }
}


