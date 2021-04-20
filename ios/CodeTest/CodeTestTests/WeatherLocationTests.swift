//
//  WeatherLocationTests.swift
//  CodeTestTests
//
//  Created by Kate Willison on 4/20/21.
//

import XCTest
@testable import CodeTest

class WeatherLocationTests: XCTestCase {
    private let decoder = JSONDecoder()

    func testValidLocation() throws {
        let location = try decoder.decode(
            WeatherLocation.self,
            from: WeatherLocation.Mocks.valid)
        
        XCTAssertEqual(location.id, "1")
        XCTAssertEqual(location.name, "Honolulu")
        XCTAssertEqual(location.status, .sunny)
        XCTAssertEqual(location.temperature, 25)
    }
    
    func testLocationWithUnknownStatus() throws {
        let location = try decoder.decode(
            WeatherLocation.self,
            from: WeatherLocation.Mocks.unknownStatus)
        
        XCTAssertEqual(location.id, "1")
        XCTAssertEqual(location.name, "San Francisco")
        XCTAssertEqual(location.status, .unknown)
        XCTAssertEqual(location.temperature, 18)
    }
    
    func testLocationWithMissingIdentifierThrows() {
        var error: Error?

        XCTAssertThrowsError(
            try decoder.decode(
                WeatherLocation.self,
                from: WeatherLocation.Mocks.missingIdentifier)) {
            
            error = $0
        }
        
        XCTAssertTrue(error is DecodingError)
        
        switch error as! DecodingError {
        case .keyNotFound(let key, _):
            XCTAssertEqual(key.stringValue, "id")
        default: XCTFail("Incorrect error type!")
        }
    }
}

extension WeatherLocation {
    enum Mocks {
        static var valid: Data {
            return """
            {
                "id": "1",
                "name": "Honolulu",
                "status": "SUNNY",
                "temperature": 25
            }
            """.data(using: .utf8)!
        }

        static var missingIdentifier: Data {
            return """
            {
                "name": "Milwaukee",
                "status": "CLOUDY",
                "temperature": 4
            }
            """.data(using: .utf8)!
        }
        
        static var unknownStatus: Data {
            return """
            {
                "id": "1",
                "name": "San Francisco",
                "status": "CARL_THE_FOG",
                "temperature": 18
            }
            """.data(using: .utf8)!
        }
    }
}
