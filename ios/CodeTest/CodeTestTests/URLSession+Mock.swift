//
//  URLSession+Mock.swift
//  CodeTestTests
//
//  Created by Kate Willison on 4/21/21.
//

import Foundation
@testable import CodeTest

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
}

class MockURLSession: URLSessionProtocol {
    var dataTask = MockURLSessionDataTask()
    var result: (Data?, URLResponse?, Error?)

    init(result: (Data?, URLResponse?, Error?)) {
        self.result = result
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        // Pass the result values to the completion handler directly
        completionHandler(result.0, result.1, result.2)
        
        return dataTask
    }
}
