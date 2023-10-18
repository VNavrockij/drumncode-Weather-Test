//
//  UICollectionView+Extension.swift
//  drumncode-Weather-Test
//
//  Created by Vitalii Navrotskyi on 18.10.2023.
//

import UIKit

public extension UICollectionView {
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
            let cellId = String(describing: type)
            register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: identifier ?? cellId)
        }

    func dequeueCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T? {
            dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
        }
}

public extension UICollectionViewCell {
    static var identifier: String { String(describing: self) }
}
