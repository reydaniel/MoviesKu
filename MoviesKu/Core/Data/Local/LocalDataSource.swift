//
//  LocalDataSource.swift
//  MoviesKu
//
//  Created by ReyDaniel on 22/11/21.
//

import Foundation
import Combine
import RealmSwift

protocol LocalDataSourceProtocol {
    func getMovies() -> AnyPublisher<[MovieEntity], Error>
    func addMovies(from movie: [MovieEntity]) -> AnyPublisher<Bool, Error>
    func getDetail(id: Int) -> AnyPublisher<MovieEntity, Error>
}

final class LocalDataSource: NSObject {
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> LocalDataSource = { realmDatabase in
        return LocalDataSource(realm: realmDatabase)
    }
}

extension LocalDataSource: LocalDataSourceProtocol {
    func getMovies() -> AnyPublisher<[MovieEntity], Error> {
        return Future<[MovieEntity], Error> { completion in
            if let realm = self.realm {
                let movies: Results<MovieEntity> = {
                    realm.objects(MovieEntity.self)
                        .sorted(byKeyPath: "title", ascending: true)
                }()
                completion(.success(movies.toArray(ofType: MovieEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func addMovies(from movie: [MovieEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        for movie in movie {
                            realm.add(movie, update: .all)
                        }
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestfailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func getDetail(id: Int) -> AnyPublisher<MovieEntity, Error> {
        return Future<MovieEntity, Error> { completion in
            if let realm = self.realm {
                let movies: Results<MovieEntity> = {
                    realm.objects(MovieEntity.self)
                        .filter("id == \(id)")
                }()
                guard let item = movies.first else { return }
                
                completion(.success(item))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for index in 0 ..< count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        return array
    }
}
