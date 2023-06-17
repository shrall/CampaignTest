//
//  WebService.swift
//  CampaignTest
//
//  Created by Marshall Kurniawan on 17/06/23.
//

import Foundation

class WebService {
    func getMovies(url: NSMutableURLRequest, completion: @escaping ([Movie]?) -> ()) {
        URLSession.shared.dataTask(with: url as URLRequest) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let result = try? JSONDecoder().decode(Starter.self, from: data)

                if let result = result {
                    completion(result.results)
                }
            }
        }.resume()
    }
    
    func getMovieDetail(url: NSMutableURLRequest, completion: @escaping (MovieDetail?) -> ()) {
        URLSession.shared.dataTask(with: url as URLRequest) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let result = try? JSONDecoder().decode(MovieDetail.self, from: data)

                if let result = result {
                    completion(result)
                }
            }
        }.resume()
    }
}
