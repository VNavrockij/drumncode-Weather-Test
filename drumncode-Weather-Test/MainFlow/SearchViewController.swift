//
//  SearchViewController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 17.10.2023.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    var dataToSend: String = "Paris"
    var searchHandler: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar

        searchBar.delegate = self

        searchHandler = { [weak self] searchText in
            // Выполняйте нужные действия с текстом поиска (например, передача на другой экран)
            guard let firstViewController = self?.storyboard?.instantiateViewController(withIdentifier: "MainController") as? MainController else { return }
            
            firstViewController.receivedData = self?.dataToSend
            self?.navigationController?.pushViewController(firstViewController, animated: true)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let searchText = searchBar.text {
                // Вызов замыкания для передачи текста в другой UIViewController
                searchHandler?(searchText)
            }
        }
}
