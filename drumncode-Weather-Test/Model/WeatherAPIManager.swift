//
//  WeatherAPIManager.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import Foundation

final class WeatherAPIManager {
    static let shared: WeatherAPIManager = .init()
    private init() {}

    enum Constants {
        static let baseUrl: String = "https://api.weatherapi.com/v1"
        static let key: String = "1f4cb4b07b1349fa90194950231010"
    }

    enum Path {
        static let fetchWheather: String = "/forecast.json"
        static let fetchCities: String = "/search.json"
    }

    private lazy var dateFrmatter: DateFormatter = {
        let value: DateFormatter = .init()
        value.dateFormat = "HH:mm"
        return value
    }()

    lazy var decoder: JSONDecoder = {
        let value: JSONDecoder = .init()
        value.dateDecodingStrategy = .formatted(dateFrmatter)
        value.keyDecodingStrategy = .convertFromSnakeCase
        return value
    }()

    lazy var encoder: JSONEncoder = {
        let value: JSONEncoder = .init()
        value.dateEncodingStrategy = .formatted(dateFrmatter)
        value.keyEncodingStrategy = .convertToSnakeCase
        return value
    }()
}
