//
//  MoviePosterResult.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/26/24.
//

struct MoviePosterResult: Codable {
    let response: String
    let poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case response = "Response"
        case poster = "Poster"
    }
}
