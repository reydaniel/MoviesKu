//
//  RemoteDataSource.swift
//  MoviesKu
//
//  Created by ReyDaniel on 20/11/21.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol: AnyObject {
    func getMovies() -> AnyPublisher<[MoviesList], Error>
    func getNowPlaying() -> AnyPublisher<[MoviesList], Error>
//    func getMovieDetail(id: Int) -> AnyPublisher<[MoviesDetailResponse], Error>
    func searchMovie(name: String) -> AnyPublisher<[MoviesList], Error>
}

final class RemoteDataSource: NSObject {
    private override init() {}
    
    static let sharedInstance: RemoteDataSource = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    func getMovies() -> AnyPublisher<[MoviesList], Error> {
        return Future<[MoviesList], Error> { completion in
            if let url = URL(string: Endpoints.Gets.list.url) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: MoviesResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func getNowPlaying() -> AnyPublisher<[MoviesList], Error> {
        return Future<[MoviesList], Error> { completion in
            if let url = URL(string: Endpoints.Gets.nowPlaying.url) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: MoviesResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func searchMovie(name: String) -> AnyPublisher<[MoviesList], Error> {
        return Future<[MoviesList], Error> { completion in
            if let url = URL(string: Endpoints.Gets.search(movie: name).url) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: MoviesResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    
}
