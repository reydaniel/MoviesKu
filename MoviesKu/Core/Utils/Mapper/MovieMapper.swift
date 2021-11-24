//
//  MovieMapper.swift
//  MoviesKu
//
//  Created by ReyDaniel on 20/11/21.
//

final class MovieMappper {
    static func mapMovieResponseToDomain(input movieResponse: [MoviesList]) -> [MovieModel] {
        return movieResponse.map { result in
            return MovieModel(
                id: result.id,
                title: result.title ?? "No Title",
                image: result.image ?? "No Image",
                average: result.average ?? 0.0
            )
        }
    }
    
//    static func mapCategoryResponseToEntity(input movieResponse: [MoviesList]) -> [MovieEntity] {
//        return movieResponse.map { result in
//            let newCategory = MovieEntity()
//            newCategory.id = result.id
//            newCategory.title = result.title ?? "No Title"
//            newCategory.image = result.image ?? "No Image"
//            newCategory.average = result.average ?? 0.0
//            return newCategory
//        }
//    }
}
