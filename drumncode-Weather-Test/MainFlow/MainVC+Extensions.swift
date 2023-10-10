//
//  MainVC+Extensions.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import UIKit

extension MainController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let city = searchTextField.text else { return }

        weatherManager.fetchWeather(cityName: city) { weatherData in
            self.setUI(weatherData: weatherData)
        }
        searchTextField.text = ""
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
        guard let url = URL(string: "https:\(weatherData.current.condition.icon)") else { return }

        DispatchQueue.main.async {
            self.conditionImageView.imageFrom(url: url)
            self.cityLabel.text = weatherData.location.name
            self.temperatureLabel.text = String(weatherData.current.tempC) + "℃"
        }
    }
}
