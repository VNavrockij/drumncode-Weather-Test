//
//  MainViewController+Extensions.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import UIKit

// MARK: set UI elements
extension MainViewController {
    func setUI(weatherData: CurrentWeather) {
        guard let url = URL(string: "\(Constatnts.https)\(weatherData.current.condition.icon)") else { return }

        DispatchQueue.main.async {
            self.configureUI(weatherData, url)
        }
    }
}

// MARK: - Save Last Session
extension MainViewController {
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

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 90, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(withType: HourlyCollectionViewCell.self,
                                                    for: indexPath)
        else { return .init()}

        let forecastDay = hourlyWeather?.forecast.forecastday[0].hour[indexPath.row]

        cell.configureCell(forecast: forecastDay)
        return cell
    }
}
