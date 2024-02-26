//
//  MobieInfoManager.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/24/24.
//

import UIKit

protocol MovieInfoDelegate {
    func didFetchMovieInfo(_ movieInfoManager: MovieInfoManager, movieDetail: MovieDetailInfo?, index: Int)
    func didFailWithDataError(error: Error)
    func didFailWithDecodeError(error: Error)}

class MovieInfoManager {
    var delegate: MovieInfoDelegate?
    
    func MovieDetail(movieCd: String, index: Int) {
        let kobis = Kobis()
        let param = MovieInfoRequest(
            key: Bundle.main.kobisApiKey ?? "",
            movieCd: movieCd
        )
        
        let url = kobis.getMovieInfoURL() + param.getParm()
        if let urlRequest = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlRequest) { [self] (data, response, error) in
                if error != nil {
                    delegate?.didFailWithDataError(error: error!)
                    return
                }
                if let dataReceived = data {
                    if let movieDetailInfo = parseJSON(responseData: dataReceived) {
                        delegate?.didFetchMovieInfo(self, movieDetail: movieDetailInfo, index: index)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(responseData: Data) -> MovieDetailInfo? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieInfoResponse.self, from: responseData)
            let movieDetailInfo = decodedData.toMovieDetailInfo()
            return movieDetailInfo
        } catch {
            delegate?.didFailWithDecodeError(error: error)
            return nil
        }
    }
}
