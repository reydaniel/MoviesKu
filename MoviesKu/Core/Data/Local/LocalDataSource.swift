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
    func getDetail(id: Int) -> AnyPublisher<MovieEntity, Error>
    func addMovies(id: Int, from movie: MovieEntity) -> AnyPublisher<Bool, Error>
    func deleteMovies(id: Int) -> AnyPublisher<Bool, Error>
    func checkID(id: Int) -> Bool
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
    func checkID(id: Int) -> Bool {
        var found = false
        
        if let realm = realm {
            let movies: Results<MovieEntity> = {
                realm.objects(MovieEntity.self)
            }()
            
            let entityData = movies.toArray(ofType: MovieEntity.self)
            for entityData in entityData {
                if id == entityData.id {
                    found = true
                }
            }
        }
        
        return found
    }
    
    func getMovies() -> AnyPublisher<[MovieEntity], Error> {
        return Future<[MovieEntity], Error> { completion in
            if let realm = self.realm {
                let movies: Results<MovieEntity> = {
                    realm.objects(MovieEntity.self)
                }()
                completion(.success(movies.toArray(ofType: MovieEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func addMovies(id: Int, from movie: MovieEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realms = self.realm {
                do {
                    try realms.write{
                        realms.add(movie)
                    }
                    completion(.success(true))
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
    
    func deleteMovies(id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    let movies: Results<MovieEntity> = {
                        realm.objects(MovieEntity.self)
                            .filter("id == \(id)")
                    }()
                    guard let item = movies.first else { return }
                    try realm.write({
                        realm.delete(item)
                        print("deleted")
                    })
                } catch {
                    completion(.failure(DatabaseError.requestfailed))
                }
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
