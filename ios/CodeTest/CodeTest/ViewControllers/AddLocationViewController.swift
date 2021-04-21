//
//  AddLocationViewController.swift
//  CodeTest
//
//  Created by Kate Willison on 4/20/21.
//

import UIKit

final class AddLocationViewController: UIViewController {
    
    private var controller: AddLocationController!
    
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var temperatureField: UITextField!
    @IBOutlet weak var cloudCoverStackView: UIStackView!
    
    // TODO: Lift common setup methods into generic functions
    static func create(controller: AddLocationController) -> AddLocationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboardIdentifier = "AddLocationViewController"

        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! AddLocationViewController

        viewController.controller = controller
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.bind(view: self)
        setup()
    }
    
    @IBAction func userDidSelectSave(_ sender: UIButton) {
        controller.addLocation(
            name: locationNameField.text,
            temperature: Int(temperatureField.text ?? ""),
            status: nil) // TODO: Implement current selected value
    }
    
    @IBAction func userDidSelectClose(_ sender: UIButton) {
        dismissView()
    }
}

extension AddLocationViewController: AddLocationView {
    func displayError(_ error: LocationViewError) {
        let alertController: UIAlertController
        
        switch error {
        case .serverError:
            alertController = UIAlertController(
                title: "Error",
                message: "Something went wrong",
                preferredStyle: .alert)

        case .validationError:
            alertController = UIAlertController(
                title: "Error",
                message: "Please fill out a proper name, temperature, and current cloud cover.",
                preferredStyle: .alert)
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func dismissView() {
        // TODO: Implement navigation handling
    }
}

extension AddLocationViewController {
    private func setup() {
        populateCloudCoverSelection()
    }
    
    private func populateCloudCoverSelection() {
        // TODO: Implement
    }
}
