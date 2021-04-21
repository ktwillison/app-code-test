//
//  AddLocationController.swift
//  CodeTest
//
//  Created by Kate Willison on 4/21/21.
//

import Foundation

enum LocationViewError: Error {
    case serverError, validationError
}

protocol AddLocationView {
    func displayError(_ error: LocationViewError)
    func dismissView()
}

class AddLocationController {
    var view: AddLocationView?

    init() {}

    internal func bind(view: AddLocationView) {
        self.view = view
    }
    
    // MARK: Private
    private let service = WeatherLocationService()
}

extension AddLocationController {
    func addLocation(name: String?, temperature: Int?, status: WeatherLocation.Status?) {
        guard let name = name, let temperature = temperature, let status = status else {
            view?.displayError(.validationError)
            return
        }

        service.add(locationName: name, temperature: temperature, status: status) { result in
            switch result {
            case .failure:
                self.view?.displayError(.serverError)
                
            case .success:
                self.view?.dismissView()
            }
        }
    }
}
