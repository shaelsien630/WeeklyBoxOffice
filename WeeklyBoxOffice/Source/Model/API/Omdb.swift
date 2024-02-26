//
//  Omdb.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/26/24.
//

struct Omdb {
    let baseURL = "https://www.omdbapi.com/"
    
    func getBaseURL() -> String {
        return baseURL
    }
}

struct MoviePosterRequest {
    let key: String
    let title: String
    
    func getParm() -> String {
        return "?apikey=" + key + "&t=" + title
    }
}
