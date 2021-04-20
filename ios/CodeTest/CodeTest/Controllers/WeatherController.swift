//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import Foundation

protocol WeatherView {
    func showEntries()
    func displayError()
}

class WeatherController {
    var view: WeatherView?

    public private(set) var entries: [WeatherLocation] = []

    init() {}

    internal func bind(view: WeatherView) {
        self.view = view
        refresh()
    }
    
    // MARK: Private
    private let service = WeatherLocationService()
}

extension WeatherController {
    func refresh() {
        service.fetchAll { result in
            switch result {
            case .failure:
                self.view?.displayError()
                
            case .success(let result):
                // Remove any entries with unknown status types from the results
                self.entries = result.locations.compactMap({ weatherLocation in
                    switch weatherLocation.status {
                    case .unknown: return nil
                    default: return weatherLocation
                    }
                })
                
                self.view?.showEntries()
            }
        }
    }
}
