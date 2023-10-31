//
//  SearchViewController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 17.10.2023.
//

import UIKit
// MARK: - DataManager
final class DataManager: Codable {
    static let shared = DataManager()
    var arrCities: [String] = [] {
        didSet {

        }
    }
}
// MARK: - SearchViewController
class SearchViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    var searchHandler: ((String) -> Void)?
    let weatherService = WeatherService()
    var arrSearchCities: [String] = [] {
        didSet {
//            print(arrSearchCities)
        }
    }
    
    private lazy var customSearchController: CustomSearchResultsController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let customSearchVC = storyboard.instantiateViewController(withIdentifier: "CustomSearchResultsController")
                as? CustomSearchResultsController else { return .init() }

        return customSearchVC
    }()

    private lazy var searchController: UISearchController = {
        let value: UISearchController = .init(searchResultsController: customSearchController)
        value.searchResultsUpdater = self
        value.searchBar.delegate = self
        return value
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerCell(type: SearchTableViewCell.self)

        self.title = "Search"

        // Настройка UISearchController

        configureSearchController()

        //        navigationItem.titleView = searchBar


        customSearchController.searchHandler = { [weak self] searchText in
            // Обработка результатов поиска
            self?.handleSearch(with: searchText)
        }

        searchHandlerFunc()
        setLastSession()
    }

    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.loadViewIfNeeded()
        searchController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
    }

    // Функция для обработки результатов поиска
    private func handleSearch(with searchText: String) {
        if let searchText = self.searchController.searchBar.text {
            reloadData()
            saveLastSearch(arrCities: DataManager.shared.arrCities)
            searchHandler?(searchText)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText.count >= Constatnts.minCharacterForSearch {
            weatherService.fetchCities(cityName: searchText) { searchCity in
                self.customSearchController.fillSearchedCities(cities: searchCity)
//                self.arrSearchCities = searchCity
            }
        } else if searchText.count <= Constatnts.minCharacterForSearch {
            self.customSearchController.fillSearchedCities(cities: [])
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
}
// MARK: - UITableViewDelegate
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
//        switch indexPath.section {
//            case 0:
//                DataManager.shared.arrCities.append(self.arrSearchCities[indexPath.row].name)
//                tableView.reloadData()
//                saveLastSearch(arrCities: DataManager.shared.arrCities)
//                searchHandler?(arrSearchCities[indexPath.row].name)
//            case 1:
                searchHandler?(DataManager.shared.arrCities[indexPath.row])
//            default:
//                break
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
            case 0:
                return ""
            case 1:
                return Constatnts.lastSearch
            default:
                return ""
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
                return .zero
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: Constatnts.tableViewCellIdentifier, for: indexPath)
        guard
            let cell = tableView.dequeueCell(withType: SearchTableViewCell.self)
        else { return .init() }

//        switch indexPath.section {
//            case 0:
//                cell.configureCell(cities: arrSearchCities, indexPath: indexPath)
//                cell.hideCountryLabel(section: indexPath.section)
//            case 1:
                cell.configureCell(city: DataManager.shared.arrCities[indexPath.row])
                cell.hideCountryLabel(section: indexPath.section)
//            default:
//                break
//        }

        return cell
    }
}

// MARK: - extension SearchViewController
private extension SearchViewController {
    func saveLastSearch(arrCities: [String]) {
        guard
            (try? UserDefaults.standard.setObject(arrCities, forKey: Constatnts.lastSearchFromTableView)) != nil
        else { return }
    }

    func setLastSession() {
        guard
            let lastSearch = try? UserDefaults.standard.getObject(forKey: Constatnts.lastSearchFromTableView,
                                                                  castTo: [String].self)
        else { return }

        DataManager.shared.arrCities = lastSearch
        tableView.reloadData()
    }

    func searchHandlerFunc() {
        searchHandler = { searchText in
            if let firstViewController = self.navigationController?.viewControllers.first as? MainViewController {
                firstViewController.receivedData = searchText
                self.navigationController?.popToViewController(firstViewController, animated: true)
            }
        }
    }
    func reloadData() {
        tableView.reloadData()
    }
}
