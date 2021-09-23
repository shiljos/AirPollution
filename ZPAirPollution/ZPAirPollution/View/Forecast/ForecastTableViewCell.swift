//
//  ForecastTableViewCell.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import UIKit

final class ForecastTableViewCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with airQualityIndex: String, _ hour: String, _ color: UIColor) {
        textLabel?.text = hour
        accessoryType = .disclosureIndicator
        detailTextLabel?.text = airQualityIndex
        backgroundColor = color
    }
}
