//
//  HourlyCollectionViewCell+Extension.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 12.10.2023.
//

import Foundation

extension HourlyCollectionViewCell {
    func formatTimeString(_ inputString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: inputString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
