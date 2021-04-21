//
//  WeatherLocationServiceTests.swift
//  CodeTestTests
//
//  Created by Kate Willison on 4/21/21.
//

import XCTest
@testable import CodeTest

class WeatherLocationServiceTests: XCTestCase {
    func testSuccessfulFetchAll() {
        let mockSession = createMockSession(
            using: WeatherLocationService.Mocks.validFetchAll,
            statusCode: 200,
            error: nil)
        
        let service = WeatherLocationService(with: mockSession)
        
        service.fetchAll() { result in
            switch result {
            case .failure: XCTFail()
            case .success(let locationsResult):
                XCTAssertEqual(locationsResult.locations.count, 2)
            }
        }
    }
    
    func testFetchAllWithEmptyResult() {
        let mockSession = createMockSession(
            using: WeatherLocationService.Mocks.emptyResult,
            statusCode: 200,
            error: nil)
        
        let service = WeatherLocationService(with: mockSession)
        
        service.fetchAll() { result in
            switch result {
            case .failure(let error):
                switch error {
                case .resultError: break
                case .serviceError, .requestError: XCTFail()
                }
            case .success: XCTFail()
            }
        }
    }
    
    func testFetchAllWithServerError() {
        let mockSession = createMockSession(
            using: WeatherLocationService.Mocks.validFetchAll,
            statusCode: 400,
            error: nil)
        
        let service = WeatherLocationService(with: mockSession)
        
        service.fetchAll() { result in
            switch result {
            case .failure(let error):
                switch error {
                case .serviceError: break
                case .resultError, .requestError: XCTFail()
                }
            case .success: XCTFail()
            }
        }
    }
    
    func testSuccessfulDelete() {
        let mockSession = createMockSession(
            using: WeatherLocationService.Mocks.emptyResult,
            statusCode: 200,
            error: nil)
        
        let service = WeatherLocationService(with: mockSession)
        
        service.delete(identifier: "byebye") { result in
            switch result {
            case .failure: XCTFail()
            case .success: break
            }
        }
    }
    
    func testSuccessfulAdd() {
        let mockSession = createMockSession(
            using: WeatherLocationService.Mocks.emptyResult,
            statusCode: 200,
            error: nil)
        
        let service = WeatherLocationService(with: mockSession)

        service.add(locationName: "Hello", temperature: 20, status: .sunny) { result in
            switch result {
            case .failure: XCTFail()
            case .success: break
            }
        }
    }
    
    // MARK: Private
    
    private func createMockSession(using data: Data?, statusCode: Int, error: Error?) -> MockURLSession {
        
        let response = HTTPURLResponse(
            url: URL(string: "url")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)

        return MockURLSession(result: (data, response, error))
    }
}

extension WeatherLocationService {
    enum Mocks {
        static var validFetchAll: Data {
            return LocationsResult.Mocks.validFetchAll
        }
        
        static var emptyResult: Data {
            return "{}".data(using: .utf8)!
        }
    }
}
