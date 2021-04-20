//
//  WeatherLocationService.swift
//  CodeTest
//
//  Created by Kate Willison on 4/20/21.
//

import Foundation

struct APIRequest {
    // TODO: Support method distinction, headers etc, layer of abstraction. Moya structure?
    // TODO: Add new & existing endpoints
    var host: String
    var target: String
    
    var url: URL? {
        return URL(string: host + target)
    }
}

struct WeatherLocationService {
    let session = URLSession()
    let decoder = JSONDecoder()
    
    private enum Request {
        static let fetchAll = APIRequest(host: "", target: "")
    }

    func fetchAll(completion: @escaping (Result<LocationsResult, WeatherLocationServiceError>) -> Void) {
        guard let url = Request.fetchAll.url else {
            completion(.failure(.requestError))
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let task = session.dataTask(with: request) { (data, _, error) in
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
        
        task.resume()
    }
}

enum WeatherLocationServiceError: Error {
    case requestError
    case resultError
    case serviceError(Error?)
}
