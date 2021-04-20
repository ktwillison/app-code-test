//
//  TargetType.swift
//  CodeTest
//
//  Created by Kate Willison on 4/20/21.
//

import Foundation

protocol TargetType {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTP.Method { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    
    var defaultTimeoutInterval: TimeInterval { get }
    var request: URLRequest? { get }
}

extension TargetType {
    var defaultTimeoutInterval: TimeInterval {
        return 10
    }

    var request: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: defaultTimeoutInterval)
        
        request.httpMethod = method.rawValue
        
        headers.forEach { headerField in
            request.addValue(headerField.value, forHTTPHeaderField: headerField.key)
        }
        
        switch encoding {
        case .urlParameter:
            break
        case .jsonBody:
            guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return nil // TODO: Throw request error?
            }
            request.httpBody = data
        }

        return request
    }
    
    // MARK: Private
    private var url: URL? {
        guard var urlComponents = URLComponents(string: baseUrl + path) else { return nil }

        switch encoding {
        case .urlParameter:
            let queryItems = parameters.map({ URLQueryItem(name: $0, value: $1 as? String) })
            urlComponents.queryItems?.append(contentsOf: queryItems)
        case .jsonBody:
            break
        }
        
        return urlComponents.url
    }
    
    // Note: By default, parameters are sent in the body for POST and UPDATE requests, and encoded
    // in the URL for other request types. We can easily refactor this to separate properties if
    // e.g. we ever need to send information in both.
    private var encoding: HTTP.Encoding {
        switch method {
        case .delete, .get: return .urlParameter
        case .post, .update: return .jsonBody
        }
    }
}
