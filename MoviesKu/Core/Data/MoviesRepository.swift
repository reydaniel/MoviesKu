//
//  MoviesRepository.swift
//  MoviesKu
//
//  Created by ReyDaniel on 20/11/21.
//

import Foundation
import Combine

protocol MoviesRepositoryProtocol {
    func getMovies() -> AnyPublisher<[MovieModel], Error>
    func getNowPlaying() -> AnyPublisher<[MovieModel], Error>
    func searchMovie(name: String) -> AnyPublisher<[MovieModel], Error>
    func getDetail(id: Int) -> AnyPublisher<DetailModel, Error>
}

final class MoviesRepository: NSObject {
    typealias MovieInstance = (RemoteDataSource, LocalDataSource) -> MoviesRepository
    
    fileprivate let remote: RemoteDataSource
    fileprivate let local: LocalDataSource
        
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
        return self.local.getDetail(id: id)
            .flatMap { result -> AnyPublisher<DetailModel, Error> in
                if id != result.id {
                    print("belum ada")
                    return self.remote.getMovieDetail(id: id)
                        .map { MovieMappper.mapDetailResponseToDomain(input: $0)}
                        .eraseToAnyPublisher()
                } else {
                    return self.local.getDetail(id: id)
                        .map { MovieMappper.mapDetailEntityToDomain(input: $0)}
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
}
