//
//  WeatherLocationServiceTargetTests.swift
//  CodeTestTests
//
//  Created by Kate Willison on 4/20/21.
//

import XCTest
@testable import CodeTest

class WeatherLocationServiceTargetTests: XCTestCase {
    func testFetchAllRequest() {
        let target = WeatherLocationServiceTarget.fetchAll
        
        XCTAssertEqual(target.request?.url?.absoluteString, "https://app-code-test.kry.pet/locations")
        XCTAssertEqual(Array(target.request!.allHTTPHeaderFields!.keys), ["X-Api-Key"])
        XCTAssertEqual(target.request?.httpMethod, HTTP.Method.get.rawValue)
        XCTAssertNil(target.request?.httpBody)
    }
    
    func testDeleteRequest() {
        let target = WeatherLocationServiceTarget.delete(identifier: "123")
        
        XCTAssertEqual(target.request?.url?.absoluteString, "https://app-code-test.kry.pet/locations/123")
        XCTAssertEqual(Array(target.request!.allHTTPHeaderFields!.keys), ["X-Api-Key"])
        XCTAssertEqual(target.request?.httpMethod, HTTP.Method.delete.rawValue)
        XCTAssertNil(target.request?.httpBody)
        
        XCTAssertEqual(target.parameters as? [String: String], ["id": "123"])
    }
    
    func testAddRequest() throws {
        let decoder = JSONDecoder()
        let weatherLocation = try decoder.decode(
            WeatherLocation.self,
            from: WeatherLocation.Mocks.valid)
        let target = WeatherLocationServiceTarget.add(weatherLocation)
        
        XCTAssertEqual(target.request?.url?.absoluteString, "https://app-code-test.kry.pet/locations")
        XCTAssertEqual(Array(target.request!.allHTTPHeaderFields!.keys), ["X-Api-Key"])
        XCTAssertEqual(target.request?.httpMethod, HTTP.Method.post.rawValue)
        XCTAssertNotNil(target.request?.httpBody)
        
        XCTAssertEqual(target.parameters["name"] as? String, "Honolulu")
        XCTAssertEqual(target.parameters["status"] as? String, "SUNNY")
        XCTAssertEqual(target.parameters["temperature"] as? Int, 25)
    }
}

