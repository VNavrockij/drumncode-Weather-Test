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
        let storyboard = UIStoryboard(name: Constatnts.mainStoryBoard, bundle: nil)
        guard
            let customSearchVC = storyboard.instantiateViewController(withIdentifier: Constatnts.customVC)
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

        self.title = "Search"
        tableView.registerCell(type: SearchTableViewCell.self)
        configureSearchController()
        customSearchController.searchHandler = { [weak self] searchText in
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
        searchHandler?(DataManager.shared.arrCities[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Constatnts.lastSearch
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataManager.shared.arrCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueCell(withType: SearchTableViewCell.self)
        else { return .init() }

        cell.configureCell(city: DataManager.shared.arrCities[indexPath.row])

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
