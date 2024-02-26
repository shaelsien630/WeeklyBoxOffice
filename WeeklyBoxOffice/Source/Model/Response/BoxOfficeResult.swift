//
//  BoxOfficeResult.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/23/24.
//

import Foundation

struct BoxOfficeListResponse: Codable {
    let boxOfficeResult: BoxOfficeResult
}

extension BoxOfficeListResponse {
    func toMovies() -> [Movie] {
        return boxOfficeResult.weeklyBoxOfficeList.map { $0.toMovie() }
    }
}

struct BoxOfficeResult: Codable {
    let boxofficeType: String
    let showRange: String?
    let yearWeekTime: String
    let weeklyBoxOfficeList: [BoxOfficeList]
}

struct BoxOfficeList: Codable {
    let rnum: String
    let rank: String
    let rankInten: String
    let rankOldAndNew: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let salesAmt: String
    let salesShare: String
    let salesInten: String
    let salesChange: String
    let salesAcc: String
    let audiCnt: String
    let audiInten: String
    let audiChange: String
    let audiAcc: String
    let scrnCnt: String
    let showCnt: String
}

extension BoxOfficeList {
    func toMovie() -> Movie {
        return Movie(
            code: movieCd,
            name: movieNm,
            openDate: openDt.asDate() ?? Date(),
            boxOfficeInfo: BoxOfficeInfo(
                rank: Int(rank) ?? 0,
                rankInten: Int(rankInten) ?? 0,
                rankOldAndNew: rankOldAndNew,
                audienceAccumulation: Int(audiAcc) ?? 0
            )
        )
    }
}
