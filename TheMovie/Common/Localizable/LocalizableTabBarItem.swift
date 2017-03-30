//
//  LocalizableTabBarItem.swift
//  Nordnet
//
//  Created by Valeriu POPA on 10/20/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import UIKit

class LocalizableTabBarItem: UITabBarItem {
    override func awakeFromNib() {
        super.awakeFromNib()

        if let localizableText = self.title {
            self.title = localizableText.localized
        }
    }
}
