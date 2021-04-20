//
//  HTTP.swift
//  CodeTest
//
//  Created by Kate Willison on 4/20/21.
//

import Foundation

enum HTTP {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case update = "UPDATE"
    }
    
    enum Status {
        case success, requestError, serverError, unknown
        
        static func from(_ responseCode: Int) -> Status {
            switch responseCode {
            case 200...299:
                return success
            case 400...499:
                return requestError
            case 500...599:
                return serverError
            default:
                return unknown
            }
        }
    }
    
    enum Encoding {
        case jsonBody, urlParameter
    }
}
