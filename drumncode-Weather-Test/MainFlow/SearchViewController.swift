//
//  SearchViewController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 17.10.2023.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet private weak var searchBar: UISearchBar!
    var dataToSend: String = "Paris"
    var searchHandler: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchHandler = { [weak self] searchText in

            if let firstViewController = self?.navigationController?.viewControllers.first as? MainController {
                firstViewController.receivedData = self?.dataToSend
                self?.navigationController?.popToViewController(firstViewController, animated: true)
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let searchText = searchBar.text {
                searchHandler?(searchText)
            }
        }
}
