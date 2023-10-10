//
//  WeatherManager.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import Foundation
import Alamofire

struct WeatherManager {
    func fetchWeather(cityName: String) {
        let requestWeatherAPI = WeatherAPI()
        let request = AF.request("https://api.weatherapi.com/v1/current.json?key=\(requestWeatherAPI.key)&q=\(cityName)")
        request.responseJSON { (data) in
            print(data)
        }
    }
}
