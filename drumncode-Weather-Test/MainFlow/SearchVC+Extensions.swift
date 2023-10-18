//
//  SearchVC+Extensions.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 18.10.2023.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            DataManager.shared.arrCities.append(searchText)
            reloadData()
            searchHandler?(searchText)
        }
    }
}
