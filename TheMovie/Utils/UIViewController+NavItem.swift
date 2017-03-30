//
//  UIViewController+NavItem.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/3/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

extension UIViewController {
    func setIcon(iconName: String) {
        let titleImage = UIImage(named: iconName)
        let titleView = UIImageView(image: titleImage)
        titleView.frame = CGRect(origin: navigationItem.titleView?.frame.origin ?? CGPoint.zero, size: titleImage?.size ?? CGSize.zero)
        self.navigationItem.titleView = titleView
    }
}
