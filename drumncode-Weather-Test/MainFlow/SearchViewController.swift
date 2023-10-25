//
//  SearchViewController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 17.10.2023.
//

import UIKit

class DataManager: Codable { //userdefaults
    static let shared = DataManager()
    var arrCities: [String] = []
}

class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    var searchHandler: ((String) -> Void)?
    let weatherService = WeatherService()
    var arrSearchCities: [SearchCity] = [] {
        didSet {
            tableView.reloadData()
            print(arrSearchCities)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerCell(type: SearchTableViewCell.self)

        navigationItem.titleView = searchBar

        searchHandler = { searchText in
            if let firstViewController = self.navigationController?.viewControllers.first as? MainViewController {
                firstViewController.receivedData = searchText
                self.navigationController?.popToViewController(firstViewController, animated: true)
            }
        }
        
        guard 
            let lastSearch = try? UserDefaults.standard.getObject(forKey: Constatnts.lastSearchFromTableView, 
                                                                  castTo: [String].self)
        else { return }

        DataManager.shared.arrCities = lastSearch
        tableView.reloadData()
    }

    private func reloadData() {
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, 
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.arrCities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveLastSearch(arrCities: DataManager.shared.arrCities)
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchHandler?(DataManager.shared.arrCities[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
            case 0:
                return "Autocomplite"
            case 1:
                return Constatnts.lastSearch
            default:
                return "hyeta"
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return arrSearchCities.count
            case 1:
                return DataManager.shared.arrCities.count
            default:
                return 15
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constatnts.tableViewCellIdentifier, for: indexPath)
        guard
            let cell = tableView.dequeueCell(withType: SearchTableViewCell.self)
        else { return .init() }
        // Настройте ячейку с учетом indexPath.section и indexPath.row

        switch indexPath.section {
            case 0:
                cell.configureCell(cities: arrSearchCities, indexPath: indexPath)
            case 1:
                cell.configureCell(city: DataManager.shared.arrCities[indexPath.row])
            default:
                UITableViewCell()
        }

        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            DataManager.shared.arrCities.append(searchText)
            reloadData()
            saveLastSearch(arrCities: DataManager.shared.arrCities)
            searchHandler?(searchText)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 4 {
            weatherService.fetchCities(cityName: searchText) { searchCity in
                self.arrSearchCities = searchCity
            }
        } else if searchText.count <= 4 {
            arrSearchCities = []
        }
    }
}

extension SearchViewController {
    func saveLastSearch(arrCities: [String]) {
        guard 
            (try? UserDefaults.standard.setObject(arrCities, forKey: Constatnts.lastSearchFromTableView)) != nil
        else { return }
    }
}
