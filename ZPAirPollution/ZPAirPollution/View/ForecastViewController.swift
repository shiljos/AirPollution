//
//  ViewController.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import UIKit

protocol TapIteractionDelegate : AnyObject {
    func currentViewTapped()
}

class CurrentForecastView : UIView {
    weak var interactionDelegate: TapIteractionDelegate?

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabels() {
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
    
    func setValues(_ airQuality: String, _ date: String, _ color: UIColor) {
        airQualityValueLabel.text = airQuality
        airQualityValueLabel.font = UIFont.systemFont(ofSize: 30)
        airQualityLabel.text = "Air Quality"
        dateLabel.text = date
        backgroundColor = color
    }
    
}

protocol ForecastPresenterDelegate : AnyObject {
    func updateUI()
    func setCurrentForecastViewValues(_ airQuality: String, _ dateString: String, _ color: UIColor)
    func displayDetailView(withData forecastItemDetail: ForecastItemDetailModel)
}


class ForecastViewController : UIViewController {
    
    let reuseIdentifier = "forecast-cell"
    
    var tableView: UITableView!
    var forecastPresenter: ForecastPresenter!
    
    lazy var currentForecastView: CurrentForecastView = {
        let currentForecastView = CurrentForecastView(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
        currentForecastView.configureLabels()
        currentForecastView.interactionDelegate = self
        return currentForecastView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //airPollutionViewModel = AirPollutionViewModel()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Munich"
/*
        airPollutionViewModel.viewModelToControllerBinding = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
*/
        view.backgroundColor = .white
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        

        tableView.tableHeaderView = currentForecastView
        
        forecastPresenter.delegate = self
    }
    
    
    
}

extension ForecastViewController : TapIteractionDelegate {
    func currentViewTapped() {
        forecastPresenter.getForecastDetailForCurrent()
    }
}

extension ForecastViewController : ForecastPresenterDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setCurrentForecastViewValues(_ airQuality: String, _ dateString: String, _ color: UIColor) {
        DispatchQueue.main.async {
            self.currentForecastView.setValues(airQuality, dateString, color)
        }
    }
    
    func displayDetailView(withData forecastItemDetail: ForecastItemDetailModel) {
        let detailViewController = ForecastDetailViewController(with: forecastItemDetail)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ForecastViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        forecastPresenter.getForecastDetail(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        forecastPresenter.showSectionHeaderText(for: section)
    }
}

extension ForecastViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        forecastPresenter.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastPresenter.getItemCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ForecastTableViewCell
        
        forecastPresenter.configureCell(cell, indexPath)
        return cell
    }
}

