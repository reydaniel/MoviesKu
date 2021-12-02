//
//  MovieEntity.swift
//  MoviesKu
//
//  Created by ReyDaniel on 22/11/21.
//

import Foundation
import RealmSwift

class MovieEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = "No Title Yet"
    @objc dynamic var image: String = "No Image"
    @objc dynamic var average: Double = 0.0
    @objc dynamic var tagline: String = "No Tagline"
    @objc dynamic var overview: String = "No Overview"
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
