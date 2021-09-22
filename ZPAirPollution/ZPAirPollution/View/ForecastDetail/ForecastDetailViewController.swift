//
//  ForecastDetailViewController.swift
//  ZPAirPollution
//
//  Created by Daniel on 19.09.21.
//

import UIKit

final class ForecastDetailViewController : UIViewController {
    
    var forecastDetailComponents: [ForecastDetailElement]
    
    let componentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(with forecastDetailComponents: [ForecastDetailElement]) {
        self.forecastDetailComponents = forecastDetailComponents
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
        
        configureHierarchy()
        populateDataItems()
    }
    
    func configureHierarchy() {
        view.backgroundColor = .white
        view.addSubview(componentsStackView)
        anchorStackView()
    }
    
    func anchorStackView() {
        NSLayoutConstraint.activate([
            componentsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            componentsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            componentsStackView.topAnchor.constraint(equalTo: view.topAnchor),
            componentsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    func populateDataItems() {
        forecastDetailComponents.forEach({
            let componentView = ForecastDetailView()
            componentView.configure(with: $0.description, $0.value)
            componentsStackView.addArrangedSubview(componentView)
        })
    }
}
