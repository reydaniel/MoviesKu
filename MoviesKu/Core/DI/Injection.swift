//
//  Injection.swift
//  MoviesKu
//
//  Created by ReyDaniel on 22/11/21.
//

import Foundation
import RealmSwift

final class Injection: NSObject {
    private func provideRepository() -> MoviesRepositoryProtocol {
        let realm = try? Realm()
        
        let local: LocalDataSource = LocalDataSource.sharedInstance(realm)
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        
        return MoviesRepository.sharedInstance(remote, local)
    }
    
    func provideHome() -> HomeUseCase {
        let repository = provideRepository()
        return HomeInteractor(repository: repository)
    }
    
    func provideDetail(by id: Int) -> DetailUseCase {
        let repository = provideRepository()
        return DetailInteractor(by: id, repository: repository)
    }
}
