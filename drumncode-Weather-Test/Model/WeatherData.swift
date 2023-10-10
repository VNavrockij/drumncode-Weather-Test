//
//  WeatherData.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let location: Location
    let current: Current
}

// MARK: - Current
struct Current: Codable {
    let tempC: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
    let code: Int
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let lat, lon: Double
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, lat, lon
        case localtime
    }
}
