//
//  MoviePosterManager.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/26/24.
//

import UIKit

protocol MoviePosterDelegate {
    func didFetchMoviePoster(_ moviePosterManager: MoviePosterManager, poster: String, index: Int)
    func didFailWithDataError(error: Error)
    func didFailWithDecodeError(error: Error)}

class MoviePosterManager {
    var delegate: MoviePosterDelegate?
    
    func MoviePoster(title: String, index: Int) {
        let omdb = Omdb()
        let param = MoviePosterRequest(
            key: Bundle.main.omdbApiKey ?? "",
            title: title
        )
        
        let url = omdb.getBaseURL() + param.getParm()
        if let urlRequest = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlRequest) { [self] (data, response, error) in
                if error != nil {
                    delegate?.didFailWithDataError(error: error!)
                    return
                }
                if let dataReceived = data {
                    if let moviePoster = parseJSON(responseData: dataReceived) {
                        delegate?.didFetchMoviePoster(self, poster: moviePoster, index: index)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(responseData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MoviePosterResult.self, from: responseData)
            let moviePosterUrl = decodedData.poster
            return moviePosterUrl
        } catch {
            delegate?.didFailWithDecodeError(error: error)
            return nil
        }
    }
}
