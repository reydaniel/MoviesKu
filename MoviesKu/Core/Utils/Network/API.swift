//
//  API.swift
//  MoviesKu
//
//  Created by ReyDaniel on 19/11/21.
//

import Foundation

struct API {
    static let url = "https://api.themoviedb.org/3/movie/"
    static let key = "12a7ddaa1ce899dc8acece5699a6601c"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints {
    enum Gets: Endpoint {
        case nowPlaying
        case list
        case search(movie: String)
        case detail(id: Int)
        
        public var url: String {
            switch self {
            case .nowPlaying:
                return "\(API.url)now_playing?api_key=\(API.key)"
            case .list:
                return "\(API.url)popular?api_key=\(API.key)"
            case .search(let movie):
                return "\(API.url)search/movie?api_key=\(API.key)&query=\(movie)"
            case .detail(let id):
                return "\(API.url)\(id)?api_key=\(API.key)"
            }
        }
    }
}
