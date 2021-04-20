//
//  LocationsResultTest.swift
//  CodeTestTests
//
//  Created by Kate Willison on 4/20/21.
//

import XCTest
@testable import CodeTest

class LocationsResultTest: XCTestCase {
    private let decoder = JSONDecoder()

    func testValidLocations() throws {
        let result = try decoder.decode(
            LocationsResult.self,
            from: LocationsResult.Mocks.validFetchAll)
        
        XCTAssertEqual(result.locations[0].name, "Honolulu")
        XCTAssertEqual(result.locations[1].name, "Milwaukee")
    }
    
    func testUnknownStatusLocations() throws {
        let result = try decoder.decode(
            LocationsResult.self,
            from: LocationsResult.Mocks.toleratedFetchAll)
        
        XCTAssertEqual(result.locations[0].name, "San Francisco")
        XCTAssertEqual(result.locations[0].status, .unknown)
    }
}

extension LocationsResult {
    enum Mocks {
        static var validFetchAll: Data {
            return """
            {
                "locations": [
                    {
                        "id": "1",
                        "name": "Honolulu",
                        "status": "SUNNY",
                        "temperature": 25
                    },
                    {
                        "id": "2",
                        "name": "Milwaukee",
                        "status": "CLOUDY",
                        "temperature": 4
                    },
                ]
            }
            """.data(using: .utf8)!
        }
            
        // Location 'status' is unknown
        static var toleratedFetchAll: Data {
            return """
            {
                "locations": [
                    {
                        "id": "1",
                        "name": "San Francisco",
                        "status": "CARL_THE_FOG",
                        "temperature": 18
                    }
                ]
            }
            """.data(using: .utf8)!
        }
    }
}
