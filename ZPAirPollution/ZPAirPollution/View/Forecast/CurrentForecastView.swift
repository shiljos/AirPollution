//
//  CurrentForecastView.swift
//  ZPAirPollution
//
//  Created by Daniel on 21.09.21.
//

import UIKit

protocol TapInteractionDelegate : AnyObject {
    func currentViewTapped()
}

final class CurrentForecastView : UIView {
    
    weak var interactionDelegate: TapInteractionDelegate?

    let airQualityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let airQualityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func configureHierarchy() {
        addSubview(airQualityLabel)
        addSubview(airQualityValueLabel)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            airQualityValueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            airQualityValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            airQualityLabel.bottomAnchor.constraint(equalTo: airQualityValueLabel.topAnchor, constant: -15),
            airQualityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: airQualityValueLabel.bottomAnchor, constant: 15)
        ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCurrentView(_:))))
    }
    
    @objc func tapCurrentView(_ tapGesture: UITapGestureRecognizer) {
        interactionDelegate?.currentViewTapped()
    }
    
    func setDisplayValues(with forecastElement: ForecastElement) {
        airQualityValueLabel.text = forecastElement.0
        airQualityValueLabel.font = UIFont.systemFont(ofSize: 40)
        airQualityLabel.text = "Air Quality"
        dateLabel.text = forecastElement.1
        backgroundColor = forecastElement.2
    }
}
