//
//  MoviesDetailResponse.swift
//  MoviesKu
//
//  Created by ReyDaniel on 20/11/21.
//

import Foundation

struct DetailResponse: Decodable {
    let id: Int
    let title: String?
    let image: String?
    let average: Double?
    let tagline: String?
    let overview: String?
    
    private enum CodingKeys: String, CodingKey {
        case id,title, tagline, overview
        case image = "poster_path"
        case average = "vote_average"
    }
}
