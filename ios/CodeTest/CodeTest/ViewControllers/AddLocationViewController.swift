//
//  AddLocationViewController.swift
//  CodeTest
//
//  Created by Kate Willison on 4/20/21.
//

import UIKit

final class AddLocationViewController: UIViewController, StoryboardInstantiatable, Coordinatable {
    typealias ViewControllerType = AddLocationViewController
    typealias ControllerType = AddLocationController
    
    var coordinator: MainCoordinator!
    var controller: AddLocationController!
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private var currentlySelectedStatus: WeatherLocation.Status?
    
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var temperatureField: UITextField!
    @IBOutlet weak var cloudCoverStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.bind(view: self)
        setup()
    }
    
    @IBAction func userDidSelectSave(_ sender: UIButton) {
        controller.addLocation(
            name: locationNameField.text,
            temperature: Int(temperatureField.text ?? ""),
            status: currentlySelectedStatus)
    }
    
    @IBAction func userDidSelectClose(_ sender: UIButton) {
        dismissView()
    }
    
    @objc func didSelect(_ sender: CloudCoverButton) {
        feedbackGenerator.selectionChanged()
        deselectAllCloudCoverOptions(in: cloudCoverStackView)
        sender.isSelected = true
        currentlySelectedStatus = sender.value
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
        coordinator.addLocationViewShouldDismiss()
    }
}

extension AddLocationViewController {
    private func setup() {
        populateCloudCoverSelection()
    }
    
    private func populateCloudCoverSelection() {
        // Remove all existing subviews
        cloudCoverStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add two horizontal stackViews to display the available statuses.
        // Note: yeah, this is a bit hacky, but I didn't want to go down a
        // collectionView rabbit hole in this excercise, given the time constraint 😇
        let firstRowStack = createEmojiStackView()
        let secondRowStack = createEmojiStackView()
        
        cloudCoverStackView.addArrangedSubview(firstRowStack)
        cloudCoverStackView.addArrangedSubview(secondRowStack)
        
        let countInFirstRow = WeatherLocation.Status.allCases.count / 2
        var currentAddedCount = 0
        
        // Create and configure cloud cover selection buttons
        for status in WeatherLocation.Status.allCases {
            guard status != .unknown else { continue }
            let button = CloudCoverButton.create(with: status)
            button.addTarget(self, action: #selector(didSelect(_:)), for: .touchUpInside)
            
            if currentAddedCount < countInFirstRow {
                firstRowStack.addArrangedSubview(button)
            } else {
                secondRowStack.addArrangedSubview(button)
            }
            
            currentAddedCount += 1
        }
    }
    
    private func createEmojiStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }
    
    func deselectAllCloudCoverOptions(in stackView: UIStackView) {
        for subview in stackView.subviews {
            if let button = subview as? CloudCoverButton {
                button.isSelected = false
            } else if let stackView = subview as? UIStackView {
                deselectAllCloudCoverOptions(in: stackView)
            }
        }
    }
}
