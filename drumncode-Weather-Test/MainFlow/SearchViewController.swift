//
//  SearchViewController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 17.10.2023.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!

    var searchHandler: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchHandler = { [weak self] searchText in
            if let firstViewController = self?.navigationController?.viewControllers.first as? MainViewController {
                firstViewController.receivedData = searchText
                self?.navigationController?.popToViewController(firstViewController, animated: true)
            }
        }
    }
}
