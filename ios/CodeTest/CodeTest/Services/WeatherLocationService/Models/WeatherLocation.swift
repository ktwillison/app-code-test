//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

struct WeatherLocation: Decodable {
    enum Status: String, Codable, CaseIterable {
        case cloudy = "CLOUDY"
        case sunny = "SUNNY"
        case mostlySunny = "MOSTLY_SUNNY"
        case partlySunnyRain = "PARTLY_SUNNY_RAIN"
        case thunderCloudAndRain = "THUNDER_CLOUD_AND_RAIN"
        case tornado = "TORNADO"
        case barelySunny = "BARELY_SUNNY"
        case lightening = "LIGHTENING"
        case snowCloud = "SNOW_CLOUD"
        case rainy = "RAINY"
        case unknown
    }
    let id: String
    let name: String
    let status: Status
    let temperature: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = (try? container.decode(Status.self, forKey: .status)) ?? .unknown
        self.temperature = try container.decode(Int.self, forKey: .temperature)
    }
    
    internal init(id: String, name: String, status: WeatherLocation.Status, temperature: Int) {
        self.id = id
        self.name = name
        self.status = status
        self.temperature = temperature
    }
    
    // MARK: Private
    
    // Coding keys
    private enum RootCodingKeys: String, CodingKey {
        case id, name, status, temperature
    }
}
