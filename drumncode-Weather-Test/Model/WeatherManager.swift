//
//  WeatherManager.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import Foundation
import Alamofire

struct WeatherManager {
    func fetchWeather(cityName: String, completionHandler: @escaping (CurrentWeather) -> Void) {
        let requestWeatherAPI = WeatherAPI()
        let request = AF.request("https://api.weatherapi.com/v1/forecast.json?key=\(requestWeatherAPI.key)&q=\(cityName)")
        request.responseDecodable(of: CurrentWeather.self) { response in
            switch response.result {
                case .success(let weatherData):
                    completionHandler(weatherData)
                case .failure(let weatherFetcherror):
                    print(weatherFetcherror.localizedDescription)
            }
        }
    }
}
