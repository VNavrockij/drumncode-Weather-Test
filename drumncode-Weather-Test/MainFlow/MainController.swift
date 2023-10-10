//
//  MainController.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 10.10.2023.
//

import UIKit

class MainController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    let weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self

    }
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
}
