//
//  Kobis.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/23/24.
//

struct Kobis {
    let baseURL = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/"
    let boxOfficePath = "boxoffice/searchWeeklyBoxOfficeList.json"
    let movieInfoPath = "movie/searchMovieInfo.json"
    
    func getBoxOfficeURL() -> String {
        return baseURL + boxOfficePath
    }
    
    func getMovieInfoURL() -> String {
        return baseURL + movieInfoPath
    }
}

struct BoxOfficeRequest {
    let key: String
    let targetDt: String
    let weekGb: String
    
    func getParm() -> String {
        return "?key=" + key + "&targetDt=" + targetDt + "&weekGb=" + weekGb
    }
}

struct MovieInfoRequest {
    let key: String
    let movieCd: String
    
    func getParm() -> String {
        return "?key=" + key + "&movieCd=" + movieCd
    }
}
