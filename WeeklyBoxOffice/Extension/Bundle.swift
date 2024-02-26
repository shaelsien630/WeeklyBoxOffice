//
//  Bundle.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/23/24.
//

import Foundation
import OSLog

extension Bundle {
    var kobisApiKey: String? {
        guard let path = self.path(forResource: "Key", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: path),
              let key = resource["kobisApiKey"] as? String else {
            os_log(.error, log: .default, "KOBIS API KEY ERROR")
            return nil
        }
        return key
    }
    
    var omdbApiKey: String? {
        guard let path = self.path(forResource: "Key", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: path),
              let key = resource["omdbApiKey"] as? String else {
            os_log(.error, log: .default, "OMDB API KEY ERROR")
            return nil
        }
        return key
    }
}
