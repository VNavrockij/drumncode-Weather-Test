//
//  WeatherService.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import Foundation
import Alamofire

struct FetchWeatherParams: Codable {
    var key: String = WeatherAPIManager.Constants.key
    var q: String
}

struct WeatherService {
    func fetchWeather(cityName: String, completionHandler: @escaping (CurrentWeather) -> Void) {

        guard
            let url: URL = .init(string: "\(WeatherAPIManager.Constants.baseUrl)\(WeatherAPIManager.Path.fetchWheather)")
        else { return }

        let fetchWeatherParams: FetchWeatherParams = .init(q: cityName)

        AF.request(url,
                   method: .get,
                   parameters: fetchWeatherParams,
                   encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: CurrentWeather.self) { response in
            switch response.result {
                case .success(let currentWeather):
                    completionHandler(currentWeather)
                case .failure(let error):
                    print("Error fetching weather: \(error)")
            }
            
        }
    }

        func fetchCities(cityName: String, completionHandler: @escaping ([SearchCity]) -> Void) {
            guard
                let url: URL = .init(string: "\(WeatherAPIManager.Constants.baseUrl)\(WeatherAPIManager.Path.fetchCities)")
            else { return }

            let fetchWeatherParams: FetchWeatherParams = .init(q: cityName)

            AF.request(url,
                       method: .get,
                       parameters: fetchWeatherParams,
                       encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: [SearchCity].self) { response in
                switch response.result {
                    case .success(let cities):
                        completionHandler(cities)
                    case .failure(let error):
                        print("Error fetching weather: \(error)")
                }
            }
        }


//        let request = AF.request("https://api.weatherapi.com/v1/forecast.json?key=\(requestWeatherAPI.key)&q=\(cityName)")
//        request.responseDecodable(of: CurrentWeather.self) { response in
//            switch response.result {
//                case .success(let weatherData):
//                    completionHandler(weatherData)
//                case .failure(let weatherFetcherror):
//                    print(weatherFetcherror.localizedDescription)
//            }
//        }
}
