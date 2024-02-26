//
//  BoxOfficeManager.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/23/24.
//

import UIKit

protocol BoxOfficeManagerDelegate {
    func didFetchBoxOffice(_ boxOfficeManager: BoxOfficeManager, movieList: [Movie])
    func didFailWithDataError(error: Error)
    func didFailWithDecodeError(error: Error)
}

class BoxOfficeManager {
    var delegate: BoxOfficeManagerDelegate?
    
    func WeeklyBoxOffice(date targetDt: Date, weekGb: String) {
        let kobis = Kobis()
        let param = BoxOfficeRequest(
            key: Bundle.main.kobisApiKey ?? "",
            targetDt: targetDt.toString(.yyyyMMdd),
            weekGb: weekGb
        )
        
        let url = kobis.getBoxOfficeURL() + param.getParm()
        if let urlRequest = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlRequest) { [self] (data, response, error) in
                if error != nil {
                    delegate?.didFailWithDataError(error: error!)
                    return
                }
                if let dataReceived = data {
                    if let boxOfficeList = parseJSON(responseData: dataReceived) {
                        delegate?.didFetchBoxOffice(self, movieList: boxOfficeList)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(responseData: Data) -> [Movie]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BoxOfficeListResponse.self, from: responseData)
            let movieList = decodedData.toMovies()
            return movieList
        } catch {
            delegate?.didFailWithDecodeError(error: error)
            return nil
        }
    }
}
