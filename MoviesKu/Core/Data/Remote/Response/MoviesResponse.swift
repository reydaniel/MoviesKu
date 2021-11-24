//
//  MoviesResponse.swift
//  MoviesKu
//
//  Created by ReyDaniel on 20/11/21.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [MoviesList]
}

struct MoviesList: Decodable {
    let id: Int
    let title: String?
    let image: String?
    let average: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id,title
        case image = "poster_path"
        case average = "vote_average"
    }
}
