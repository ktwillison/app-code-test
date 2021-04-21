//
//  URLSession.swift
//  CodeTest
//
//  Created by Kate Willison on 4/21/21.
//

import Foundation

// Create a protocol for URLSessions and DataTasks that allow us to mock responses
// in the service for use in testing.
protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        let foundationFunction: URLSessionDataTask = dataTask(with: request, completionHandler: completionHandler)
        return foundationFunction as URLSessionDataTaskProtocol
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    // Intentionally left blank
}
