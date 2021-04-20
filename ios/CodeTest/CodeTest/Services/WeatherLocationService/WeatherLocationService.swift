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
        makeRequest(of: .fetchAll, completion: completion)
    }
    
    func delete(identifier: String, completion: @escaping (Result<EmptyResult, WeatherLocationServiceError>) -> Void) {
        makeRequest(of: .delete(identifier: identifier), completion: completion)
    }
    
    func add(_ location: WeatherLocation, completion: @escaping (Result<EmptyResult, WeatherLocationServiceError>) -> Void) {
        makeRequest(of: .add(location), completion: completion)
    }
    
    // MARK: Private
    
    // Call the completion with an appropriate error if the response is malformed,
    // returns an error code, or cannot be mapped to the given model. Otherwise on success,
    // call the completion with the correctly mapped model.
    private func makeRequest<Model: Decodable>(
        of targetType: WeatherLocationServiceTarget,
        completion: @escaping (Result<Model, WeatherLocationServiceError>) -> Void) {
        
        guard let request = targetType.request else {
            completion(.failure(.requestError))
            return
        }

        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(.resultError))
                    return
                }
                
                guard error == nil else {
                    completion(.failure(.serviceError(error)))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch HTTP.Status.from(httpResponse.statusCode) {
                    case .unknown, .success:
                        break
                        
                    case .requestError:
                        completion(.failure(.requestError))
                        return
                        
                    case .serverError:
                        completion(.failure(.serviceError(nil)))
                        return
                    }
                }
                
                do {
                    let result = try decoder.decode(Model.self, from: data)
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

// This is a bit of a hack so that we can use the same generic functions for the request logic;
// there's probably a better way to handle this, but I didn't want to take _too_ deep of a
// detour into generic-land 😇
struct EmptyResult: Decodable {
    // Intentionally left blank
}
