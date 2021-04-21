//
//  StoryboardInstantiatable.swift
//  CodeTest
//
//  Created by Kate Willison on 4/21/21.
//

import UIKit

enum Storyboard {
    case main
    case custom(identifier: String)
}

protocol StoryboardInstantiatable {
    associatedtype ViewControllerType
    associatedtype ControllerType
    associatedtype CoordinatorType
    
    static func create(with controller: ControllerType, coordinator: CoordinatorType, from storyboardType: Storyboard) -> ViewControllerType
    static var identifier: String { get }
    
    var controller: ControllerType! { get set }
    var coordinator: CoordinatorType! { get set }
}

extension StoryboardInstantiatable where Self: UIViewController, ViewControllerType: StoryboardInstantiatable {
    static func create(with controller: ControllerType, coordinator: CoordinatorType, from storyboardType: Storyboard) -> ViewControllerType {
        let storyboardInstance: UIStoryboard
        
        switch storyboardType {
        case .main:
            storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
        case .custom(let storyboardIdentifier):
            storyboardInstance = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        }
        
        var viewController = storyboardInstance.instantiateViewController(
            withIdentifier: identifier) as! ViewControllerType
        
        // TODO: there's almost certainly a way to work this without force-casting; will loop back if I get time!
        viewController.controller = (controller as! Self.ViewControllerType.ControllerType)
        viewController.coordinator = (coordinator as! Self.ViewControllerType.CoordinatorType)
        
        return viewController
    }
    
    static var identifier: String {
        String(describing: Self.self)
    }
}
