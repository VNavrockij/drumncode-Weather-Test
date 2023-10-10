//
//  WeatherManager.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import Foundation

struct WeatherManager {
    func fetchWeather(cityName: String) {
        let urlString = "\(Constants.path)\(cityName)"
        print(urlString)
    }
}
