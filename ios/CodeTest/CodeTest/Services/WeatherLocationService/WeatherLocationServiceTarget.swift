//
//  WeatherLocationServiceTarget.swift
//  CodeTest
//
//  Created by Kate Willison on 4/20/21.
//

import Foundation

enum WeatherLocationServiceTarget: TargetType {
    case fetchAll
    case delete(identifier: String)
    case add(locationName: String, temperature: Int, status: WeatherLocation.Status)
    
    var baseUrl: String { "https://app-code-test.kry.pet" }
    
    var path: String {
        switch self {
        case .fetchAll, .add:
            return "/locations"
        case .delete(let identifier):
            return "/locations/\(identifier)"
        }
    }
    
    var method: HTTP.Method {
        switch self {
        case .fetchAll:
            return .get
            
        case .add:
            return .post
            
        case .delete:
            return .delete
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .fetchAll, .add, .delete:
            return ["X-Api-Key": apiKey]
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .fetchAll:
            return [:]
            
        case .add(let locationName, let temperature, let status):
            return [
                // Note: I omit the identifier here, as it seems like something that
                // should be created on the backend, but I may be missing a good
                // reason why we'd want to create it client-side 🤔
                "name": locationName,
                "status": status.rawValue,
                "temperature": temperature
            ]
            
        case .delete(let identifier):
            return ["id": identifier]
        }
    }
    
    // MARK: Private
    
    private var apiKey: String { // TODO: Refactor if not service-specific
        guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
            let key = UUID().uuidString
            UserDefaults.standard.set(key, forKey: "API_KEY")
            return key
        }
        return apiKey
    }
}
