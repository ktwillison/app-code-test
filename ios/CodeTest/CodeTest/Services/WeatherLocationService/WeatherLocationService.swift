//
//  WeatherLocationService.swift
//  CodeTest
//
//  Created by Kate Willison on 4/20/21.
//

import Foundation

struct WeatherLocationService {
    let session = URLSession(configuration: .default)
    let decoder = JSONDecoder()

    func fetchAll(completion: @escaping (Result<LocationsResult, WeatherLocationServiceError>) -> Void) {
        guard let request = WeatherLocationServiceTarget.fetchAll.request else {
            completion(.failure(.requestError))
            return
        }

        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failure(.serviceError(error)))
                    return
                }
                
                // TODO: Map error codes
                
                // TODO: Retry logic?
                
                guard let data = data else {
                    completion(.failure(.resultError))
                    return
                }
                
                do {
                    let result = try decoder.decode(LocationsResult.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.serviceError(error)))
                }
            }
        }
        
        task.resume()
    }
}

enum WeatherLocationServiceError: Error {
    case requestError
    case resultError
    case serviceError(Error?)
}
