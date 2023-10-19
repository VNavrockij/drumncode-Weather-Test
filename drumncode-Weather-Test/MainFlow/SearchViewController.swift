//
//  SearchViewController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 17.10.2023.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    var arrCities: [String] = []
}

class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    var searchHandler: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        self.navigationItem.setHidesBackButton(true, animated: true)

        navigationItem.titleView = searchBar
        searchBar.delegate = self

        searchHandler = { [weak self] searchText in
            if let firstViewController = self?.navigationController?.viewControllers.first as? MainViewController {
                firstViewController.receivedData = searchText
                self?.navigationController?.popToViewController(firstViewController, animated: true)
            }
        }
    }

    func reloadData() {
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.arrCities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        Constatnts.lastSearch
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataManager.shared.arrCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constatnts.tableViewIdentifier,
                                                       for: indexPath)

        cell.textLabel?.text = DataManager.shared.arrCities[indexPath.row]
        return cell
    }
}

public extension UITableView {
    /**
     DequeueCell by passing the type of UITableViewCell
     - Parameter type: UITableViewCell.Type
     */
    func dequeueCell<T: UITableViewCell>(withType type: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: type.identifier) as? T
    }

    /**
     DequeueCell by passing the type of UITableViewCell and IndexPath
     - Parameter type: UITableViewCell.Type
     - Parameter indexPath: IndexPath
     */
    func dequeueCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }

}

public extension UITableViewCell {
    static var identifier: String { .init(describing: self) }
}
