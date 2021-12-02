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
    
    static func mapDetailResponseToDomain(input detailResponse: DetailResponse) -> DetailModel {
        return DetailModel(id: detailResponse.id,
                           title: detailResponse.title ?? "No Title",
                           image: detailResponse.image ?? "No Image",
                           average: detailResponse.average ?? 0.0,
                           overview: detailResponse.overview ?? "No Overview...",
                           tagline: detailResponse.tagline ?? "No Tagline here")
    }
    
    static func mapDetailResponseToEntity(input movieResponse: DetailResponse) -> MovieEntity {
        let movieEntity = MovieEntity()
        movieEntity.id = movieResponse.id
        movieEntity.title = movieResponse.title ?? ""
        movieEntity.image = movieResponse.image ?? ""
        movieEntity.average = movieResponse.average ?? 0.0
        return movieEntity
    }
    
    static func mapDetailEntityToDomain(input movieEntity: MovieEntity) -> DetailModel {
        return DetailModel(id: movieEntity.id,
                           title: movieEntity.title,
                           image: movieEntity.image,
                           average: movieEntity.average,
                           overview: movieEntity.overview,
                           tagline: movieEntity.tagline)
    }
}
