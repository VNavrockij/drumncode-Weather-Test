//
//  HourlyCollectionViewCell.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 12.10.2023.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var hourlyLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var hourlyTemperature: UILabel!

    func configureCell(forecast: Hour?) {
        guard let path = forecast?.condition.icon else { return }
        guard let url = URL(string: "\(Constatnts.https)\(path)") else { return }
        guard let hourly = forecast?.time else { return }
        guard let tempC = forecast?.tempC else { return }

        hourlyLabel?.text = formatTimeString(hourly)
        iconImageView?.imageFrom(url: url)
        hourlyTemperature?.text = String(tempC) + Constatnts.temperature
    }
}
