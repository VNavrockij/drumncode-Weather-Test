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
        guard
            let path = forecast?.condition.icon,
            let url = URL(string: "\(Constatnts.https)\(path)"),
            let tempC = forecast?.tempC,
            let hourly = forecast?.time
        else { return }

        let hourlyText = hourly.toTimeString(from: "yyyy-MM-dd HH:mm", to: "HH:mm")

        hourlyLabel?.text = hourlyText
        iconImageView?.imageFrom(url: url)
        hourlyTemperature?.text = String(tempC) + Constatnts.temperature
    }
}

 extension String {
     func toTimeString(from fromFormat: String, to toFormat: String) -> String? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = fromFormat
         if let date = dateFormatter.date(from: self) {
             dateFormatter.dateFormat = toFormat
             return dateFormatter.string(from: date)
         }
         return nil
     }
 }
