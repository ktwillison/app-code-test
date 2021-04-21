//
//  Coordinator.swift
//  CodeTest
//
//  Created by Kate Willison on 4/21/21.
//

import UIKit

protocol Coordinator: class {
    func start()
}

protocol Coordinatable {
    var coordinator: MainCoordinator! { get }
}

class MainCoordinator: Coordinator {
    enum State {
        case viewLocations(UINavigationController, WeatherViewController)
        case addLocations(UINavigationController, AddLocationViewController)
    }

    private (set) var state: State?
    private var window: UIWindow?
    
    func start() {
        let controller = WeatherController()
        let viewController = WeatherViewController.create(with: controller, coordinator: self, from: .main)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        state = .viewLocations(navigationController, viewController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

protocol WeatherViewCoordinator: class {
    func weatherViewDidSelectAdd()
}

// Note: Ideally we would split these out into separate coordinators, but there is so little
// navigation at this point that it seems like overkill
extension MainCoordinator: WeatherViewCoordinator {
    func weatherViewDidSelectAdd() {
        guard case let .viewLocations(navigationController, _) = state else { return }
        
        let controller = AddLocationController()
        let viewController = AddLocationViewController.create(with: controller, coordinator: self, from: .main)

        navigationController.present(viewController, animated: true, completion: nil)
        state = .addLocations(navigationController, viewController)
    }
}

protocol AddLocationViewCoordinator: class {
    func addLocationViewShouldDismiss()
}

extension MainCoordinator: AddLocationViewCoordinator {
    func addLocationViewShouldDismiss() {
        guard case let .addLocations(presentedViewController) = state,
              let presentingViewController = presentedViewController.presentingViewController as? WeatherViewController else { return }
        
        presentingViewController.controller.refresh()
        presentedViewController.dismiss(animated: true, completion: nil)
        
        state = .viewLocations(navigationController, rootViewController)
    }
}
