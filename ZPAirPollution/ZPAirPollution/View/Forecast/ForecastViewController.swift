//
//  ViewController.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import UIKit

protocol ForecastPresenterDelegate : AnyObject {
    func updateUI()
    func updateCurrentView(with forecastElement: ForecastElement)
    func displayDetailView(with forecastItemDetailComponents: [ForecastDetailElement])
}

typealias ForecastDetailElement = (description: String, value: String)
typealias ForecastElement = (String, String, UIColor)


final class ForecastViewController : UIViewController {
    
    let reuseIdentifier = "forecast-cell"
    
    var tableView: UITableView!
    var forecastPresenter: ForecastPresenterProtocol
    
    lazy var currentForecastView: CurrentForecastView = {
        let currentForecastView = CurrentForecastView(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
        currentForecastView.configureHierarchy()
        currentForecastView.interactionDelegate = self
        return currentForecastView
    }()
    
    init(_ forecastPresenter: ForecastPresenterProtocol = ForecastPresenter()) {
        self.forecastPresenter = forecastPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Munich"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureHierarchy()
        configurePresentation()
        configureDataSourceDelegate()
    }
    
    func configureHierarchy() {
        view.backgroundColor = .white
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        tableView.tableHeaderView = currentForecastView
        tableView.sectionHeaderTopPadding = 0.0 // iOS15
    }
    
    func configureDataSourceDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configurePresentation() {
        forecastPresenter.fetchData()
        forecastPresenter.setPresenterDelegate(self)  
    }
}

extension ForecastViewController : TapInteractionDelegate {
    func currentViewTapped() {
        forecastPresenter.showForecastDetail()
    }
}

extension ForecastViewController : ForecastPresenterDelegate {
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateCurrentView(with forecastElement: ForecastElement) {
        DispatchQueue.main.async {
            self.currentForecastView.setDisplayValues(with: forecastElement)
        }
    }
    
    func displayDetailView(with forecastDetailElements: [ForecastDetailElement]) {
        let detailViewController = ForecastDetailViewController(with: forecastDetailElements)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ForecastViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        forecastPresenter.showForecastDetail(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        forecastPresenter.titleForHeader(in: section)
    }
}

extension ForecastViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        forecastPresenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastPresenter.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ForecastTableViewCell
        
        let forecastElement = forecastPresenter.getForecastElement(for: indexPath)
        cell.configure(with: forecastElement.0, forecastElement.1, forecastElement.2)
        return cell
    }
}

