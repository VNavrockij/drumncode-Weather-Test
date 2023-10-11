//
//  MainVC+Extensions.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import UIKit

extension MainController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditingTextField()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let city = getCity(textField) else { return }

        weatherManager.fetchWeather(cityName: city) { weatherData in
            self.setUI(weatherData: weatherData)
            self.saveLastSession(weatherData)

        }
        clearTextFieldPlaceHolder()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter the city"
            return false
        }
    }

    func setUI(weatherData: CurrentWeather) {
        guard let url = URL(string: "\(Constatnts.https)\(weatherData.current.condition.icon)") else { return }

        DispatchQueue.main.async {
            self.configureUI(weatherData, url)
        }
    }

    func saveLastSession(_ weather: CurrentWeather) {
        if let jsonData = encodeWeatherToJSON(weather) {
            UserDefaults.standard.set(jsonData, forKey: "savedWeather")
        }
    }

    func encodeWeatherToJSON(_ weather: CurrentWeather) -> Data? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(weather)
            return jsonData
        } catch {
            print("Failed to encode Weather: \(error.localizedDescription)")
            return nil
        }
    }

    func decodeWeatherFromJSON(_ jsonData: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let weather = try decoder.decode(CurrentWeather.self, from: jsonData)
            return weather
        } catch {
            print("Failed to decode Weather: \(error.localizedDescription)")
            return nil
        }
    }
}
