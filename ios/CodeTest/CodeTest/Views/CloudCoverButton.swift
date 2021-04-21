//
//  CloudCoverButton.swift
//  CodeTest
//
//  Created by Kate Willison on 4/21/21.
//

import UIKit

class CloudCoverButton: UIButton {

    class func create(with value: WeatherLocation.Status) -> CloudCoverButton {
        let button = UINib(nibName: "CloudCoverButton", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! CloudCoverButton
        button.value = value
        button.setTitle(value.emoji, for: .normal)
        button.isSelected = false
        
        return button
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .green : unselectedColor
        }
    }
    
    // MARK: Private
    
    private (set) var value: WeatherLocation.Status!
    private let unselectedColor = UIColor.black.withAlphaComponent(0.07)
}
