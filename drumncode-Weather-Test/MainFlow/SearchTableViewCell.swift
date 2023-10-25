//
//  SearchTableViewCell.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 25.10.2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet private weak var searchCityLabel: UILabel!
    @IBOutlet private weak var lastWeatherLabel: UILabel!
    
    static func nib() -> UINib {
        UINib(nibName: Constatnts.tableViewCellIdentifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(city: String) {
        searchCityLabel.text = city
    }

}
