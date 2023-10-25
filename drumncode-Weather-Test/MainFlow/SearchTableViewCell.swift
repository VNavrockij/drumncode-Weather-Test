//
//  SearchTableViewCell.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 25.10.2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet private weak var searchCityLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    static func nib() -> UINib {
        UINib(nibName: Constatnts.tableViewCellIdentifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(city: String) {
        searchCityLabel.text = city
    }

    func configureCell(cities: [SearchCity], indexPath: IndexPath) {
        searchCityLabel.text = cities[indexPath.row].name
        countryLabel.text = cities[indexPath.row].country
    }

    func hideCountryLabel(section: Int) {
        countryLabel.isHidden = section == .zero ? false : true

    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
