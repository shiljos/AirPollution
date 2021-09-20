//
//  ForecastDetailViewController.swift
//  ZPAirPollution
//
//  Created by Daniel on 19.09.21.
//

import UIKit

class ForecastDetailViewController : UIViewController {
    
    var airComponents: ForecastItemDetailModel
    
    let componentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(with airComponents: ForecastItemDetailModel) {
        self.airComponents = airComponents
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("Detail view controller dismissed")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(componentsStackView)
        NSLayoutConstraint.activate([
            componentsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            componentsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            componentsStackView.topAnchor.constraint(equalTo: view.topAnchor),
            componentsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55)
        ])
        
        airComponents.forecastItemCollection().forEach({
            let componentView = ForecastDetailView()
            componentView.configureAppearance(with: String(describing: $0), value: $0.valueWithUnit)
            componentsStackView.addArrangedSubview(componentView)
        })
    }
}

class ForecastDetailView : UIView {
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureAppearance(with description: String, value: String) {
        backgroundColor = .white
        addSubview(descriptionLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        descriptionLabel.text = description
        valueLabel.text = value
        
        layer.cornerRadius = 13
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3.5
    }    
}
