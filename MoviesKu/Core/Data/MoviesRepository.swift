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
    func addMovies(id: Int) -> AnyPublisher<Bool, Error>
    func getFavorite() -> AnyPublisher<[MovieModel], Error>
    func checkID(id: Int) -> Bool
}

final class MoviesRepository: NSObject {
    typealias MovieInstance = (RemoteDataSource, LocalDataSource) -> MoviesRepository
    
    fileprivate let remote: RemoteDataSource
    fileprivate let local: LocalDataSource
    
    private init(remote: RemoteDataSource, local: LocalDataSource) {
        self.remote = remote
        self.local = local
    }
    
    static let sharedInstance: MovieInstance = { remoteRepository, localRepository  in
        return MoviesRepository(remote: remoteRepository, local: localRepository)
    }
}

extension MoviesRepository: MoviesRepositoryProtocol {
    func checkID(id: Int) -> Bool {
        return local.checkID(id: id)
    }
    
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
        if self.checkID(id: id) {
            print("ID Sudah ada")
            return self.local.getDetail(id: id)
                .map{ MovieMappper.mapDetailEntityToDomain(input: $0)}
                .eraseToAnyPublisher()
        } else {
            print("ID Belum ada")
            return self.remote.getMovieDetail(id: id)
                .map{ MovieMappper.mapDetailResponseToDomain(input: $0) }
                .eraseToAnyPublisher()
        }
    }
    
    func addMovies(id: Int) -> AnyPublisher<Bool, Error> {
        if self.checkID(id: id) {
            return self.local.deleteMovies(id: id)
        } else {
            return self.remote.getMovieDetail(id: id)
                .map { MovieMappper.mapDetailResponseToEntity(input: $0) }
                .flatMap { self.local.addMovies(id: id, from: $0) }
                .eraseToAnyPublisher()
        }
    }
    
    func getFavorite() -> AnyPublisher<[MovieModel], Error> {
        return local.getMovies()
            .map{ MovieMappper.mapMovieEntityToDomain(input: $0) }
            .eraseToAnyPublisher()
    }
    
}
