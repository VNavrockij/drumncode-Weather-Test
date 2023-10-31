//
//  CustomSearchController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 26.10.2023.
//

import UIKit

class CustomSearchResultsController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    var searchHandler: ((String) -> Void)?
    let weatherService = WeatherService()
    private var arrSearchCities: [SearchCity] = [] {
        didSet {
            tableView.reloadSections(.init(arrayLiteral: 0), with: .automatic)
            print(arrSearchCities)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadViewIfNeeded()
    }
}

extension CustomSearchResultsController {
    func fillSearchedCities(cities: [SearchCity]) {
        arrSearchCities = cities
    }
}

extension CustomSearchResultsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataManager.shared.arrCities.append(self.arrSearchCities[indexPath.row].name)
        searchHandler?(arrSearchCities[indexPath.row].name)
    }
}

extension CustomSearchResultsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrSearchCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constatnts.cellID, for: indexPath)

        cell.textLabel?.text = arrSearchCities[indexPath.row].name
        cell.detailTextLabel?.text = arrSearchCities[indexPath.row].country

        return cell
    }
}
