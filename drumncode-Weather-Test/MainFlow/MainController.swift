//
//  MainController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import UIKit
import Alamofire

class MainController: UIViewController {
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField!

    let weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self

        let data = getWeatherFromUserDefaults()

        setLastSessionUI(data)
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        endEditingTextField()
    }

    func setLastSessionUI(_ data: Any) {
        guard let newData = data as? CurrentWeather else { return }
        guard let url = URL(string: "\(Constatnts.https)\(newData.current.condition.icon)") else { return }
        
        configureUI(newData, url)
    }

    func configureUI(_ weatherData: CurrentWeather, _ url: URL) {
        conditionImageView.imageFrom(url: url)
        self.cityLabel.text = weatherData.location.name
        self.temperatureLabel.text = String(weatherData.current.tempC) + Constatnts.temperature
    }

    func getWeatherFromUserDefaults() -> CurrentWeather? {
        if let jsonData = UserDefaults.standard.data(forKey: "savedWeather") {
            return decodeWeatherFromJSON(jsonData)
        }
        return nil
    }

    func endEditingTextField() {
        searchTextField.endEditing(true)
    }

    func getCity(_ searchCity: UITextField) -> String? {
        let city = searchCity.text
        return city
    }

    func clearTextFieldPlaceHolder() {
        searchTextField.text = ""
    }
}
