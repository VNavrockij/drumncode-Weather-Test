//
//  MainController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    let weatherManager = WeatherManager()
    var hourlyWeather: CurrentWeather?

    var receivedData: String? {
        didSet {
            guard let city = receivedData else { return }

            setCityWeather(city)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        setWeather()
    }

    func setWeather() {
        if let data = getWeatherFromUserDefaults() {
            setLastSessionUI(data as Any)
        } else {
            setCityWeather(Constatnts.defaultCity)
        }
    }

    func setCityWeather(_ city: String) {
        weatherManager.fetchWeather(cityName: city) { [weak self] weatherData in
            self?.setUI(weatherData: weatherData)
            self?.saveLastSession(weatherData)
            self?.hourlyWeather = weatherData
        }
    }

    func setLastSessionUI(_ data: Any) {
        guard let newData = data as? CurrentWeather else {
            cityLabel.text = ""
            temperatureLabel.text = ""
            return
        }
        guard let url = URL(string: "\(Constatnts.https)\(newData.current.condition.icon)") else { return }

        hourlyWeather = newData

        configureUI(newData, url)
    }

    func configureUI(_ weatherData: CurrentWeather, _ url: URL) {
        self.conditionImageView.imageFrom(url: url)
        self.cityLabel.text = weatherData.location.name
        self.temperatureLabel.text = String(weatherData.current.tempC) + Constatnts.temperature
        collectionView.reloadData()
    }

    func getWeatherFromUserDefaults() -> CurrentWeather? {
        if let jsonData = UserDefaults.standard.data(forKey: Constatnts.saveSession) {
            return decodeWeatherFromJSON(jsonData)
        }
        return nil
    }
}
