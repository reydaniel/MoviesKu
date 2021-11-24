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
    @objc dynamic var title: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var average: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
