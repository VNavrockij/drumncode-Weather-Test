//
//  MainController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import UIKit
import Alamofire
// MARK: - MainViewController
class MainViewController: UIViewController {
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    let weatherService = WeatherService()
    var hourlyWeather: CurrentWeather?
    let activityIndicator = UIActivityIndicatorView(style: .large)

    var receivedData: String? {
        didSet {
            guard let city = receivedData else { return }

            setCityWeather(city)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        firstLaunch()

        collectionView.delegate = self
        collectionView.dataSource = self

        setWeather()
    }

    func configureUI(_ weatherData: CurrentWeather, _ url: URL) {
        self.conditionImageView.imageFrom(url: url)
        self.cityLabel.text = weatherData.location.name
        self.temperatureLabel.text = String(weatherData.current.tempC) + Constatnts.temperature
        collectionView.reloadData()
        self.activityIndicator.stopAnimating()
    }
}
// MARK: - extension MainViewController
private extension MainViewController {
    func setUI(weatherData: CurrentWeather) {
        guard let url = URL(string: "\(Constatnts.https)\(weatherData.current.condition.icon)") else { return }

        DispatchQueue.main.async {
            self.configureUI(weatherData, url)
        }
    }

    func firstLaunch() {
        temperatureLabel.text = ""
        cityLabel.text = ""

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    func setWeather() {
        if let data = getWeatherFromUserDefaults() {
            setLastSessionUI(data as Any)
        } else {
            setCityWeather(Constatnts.defaultCity)
        }
    }

    func setCityWeather(_ city: String) {
        weatherService.fetchWeather(cityName: city) { [weak self] weatherData in
            self?.setUI(weatherData: weatherData)
            self?.saveLastSession(weatherData)
            self?.hourlyWeather = weatherData
            self?.activityIndicator.stopAnimating()
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

    func getWeatherFromUserDefaults() -> CurrentWeather? {
        guard
            let lastSession = try? UserDefaults.standard.getObject(forKey: Constatnts.saveSession, castTo: CurrentWeather.self)
        else { return nil }

        return lastSession
    }

    func saveLastSession(_ weather: CurrentWeather) {
        guard
            (try? UserDefaults.standard.setObject(weather, forKey: Constatnts.saveSession)) != nil
        else { return }
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

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 90, height: 90)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        1.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cells = hourlyWeather?.forecast.forecastday[0].hour.count else { return 0 }

        return cells
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueCell(withType: HourlyCollectionViewCell.self, for: indexPath)
        else { return .init() }

        let forecastDay = hourlyWeather?.forecast.forecastday[0].hour[indexPath.row]

        cell.configureCell(forecast: forecastDay)
        return cell
    }
}
