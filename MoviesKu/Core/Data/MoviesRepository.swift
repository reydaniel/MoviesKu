//
//  MoviesRepository.swift
//  MoviesKu
//
//  Created by ReyDaniel on 20/11/21.
//

import Foundation
import Combine
import RealmSwift

protocol MoviesRepositoryProtocol {
    func getMovies() -> AnyPublisher<[MovieModel], Error>
    func getNowPlaying() -> AnyPublisher<[MovieModel], Error>
    func searchMovie(name: String) -> AnyPublisher<[MovieModel], Error>
    func getDetail(id: Int) -> AnyPublisher<DetailModel, Error>
    func addMovies(id: Int) -> AnyPublisher<Bool, Error>
    func getFavorite() -> AnyPublisher<[MovieModel], Error>
}

final class MoviesRepository: NSObject {
    typealias MovieInstance = (RemoteDataSource, LocalDataSource) -> MoviesRepository
    
    fileprivate let remote: RemoteDataSource
    fileprivate let local: LocalDataSource
    var realm: Realm?
    
    private init(remote: RemoteDataSource, local: LocalDataSource) {
        self.remote = remote
        self.local = local
    }
    
    static let sharedInstance: MovieInstance = { remoteRepository, localRepository in
        return MoviesRepository(remote: remoteRepository, local: localRepository)
    }
}

extension MoviesRepository: MoviesRepositoryProtocol {
    func getMovies() -> AnyPublisher<[MovieModel], Error> {
        return self.remote.getMovies()
            .map { MovieMappper.mapMovieResponseToDomain(input: $0)}
            .eraseToAnyPublisher()
    }
    
    func getNowPlaying() -> AnyPublisher<[MovieModel], Error> {
        return self.remote.getNowPlaying()
            .map { MovieMappper.mapMovieResponseToDomain(input: $0)}
            .eraseToAnyPublisher()
    }
    
    func searchMovie(name: String) -> AnyPublisher<[MovieModel], Error> {
        return self.remote.searchMovie(name: name)
            .map{ MovieMappper.mapMovieResponseToDomain(input: $0)}
            .eraseToAnyPublisher()
    }
    
    func getDetail(id: Int) -> AnyPublisher<DetailModel, Error> {
        let result = self.realm?.object(ofType: MovieEntity.self, forPrimaryKey: "id")
        
        if id != result?.id {
            print("Belum ada ID")
            return self.remote.getMovieDetail(id: id)
                .map{ MovieMappper.mapDetailResponseToDomain(input: $0) }
                .eraseToAnyPublisher()
        } else {
            print("Sudah ada")
            return self.local.getDetail(id: id)
                .map{ MovieMappper.mapDetailEntityToDomain(input: $0) }
                .eraseToAnyPublisher()
        }
        
    }
    
    func addMovies(id: Int) -> AnyPublisher<Bool, Error> {
        return self.remote.getMovieDetail(id: id)
            .map{ MovieMappper.mapDetailResponseToEntity(input: $0) }
            .flatMap { self.local.addMovies(id: id, from: $0)}
            .eraseToAnyPublisher()
    }
    
    func getFavorite() -> AnyPublisher<[MovieModel], Error> {
        return local.getMovies()
            .map{ MovieMappper.mapMovieEntityToDomain(input: $0) }
            .eraseToAnyPublisher()
    }
    
}
