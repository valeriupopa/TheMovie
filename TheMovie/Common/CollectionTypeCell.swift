//
//  CollectionTypeCell.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/16/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

extension UICustomCellRegister where Self: UICollectionViewCell {
    static func register(to collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
}

extension UICustomCellRegister where Self: UITableViewCell {
    static func register(to tableView: UITableView) {
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}
