//
//  LocalizableNavigationItem.swift
//  Nordnet
//
//  Created by Valeriu POPA on 11/16/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import UIKit

class LocalizableNavigationItem: UINavigationItem {

    override func awakeFromNib() {
        super.awakeFromNib()

        if let localizableText = self.title {
            self.title = localizableText.localized
        }
    }
}
