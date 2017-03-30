//
//  UICollectionView+Register.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/3/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register(cell : AnyClass) {
        let identifier = "\(type(of: cell))"
        self.register(cell, forCellWithReuseIdentifier: identifier)
    }
}
