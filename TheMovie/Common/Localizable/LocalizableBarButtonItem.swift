//
//  LocalizableBarButton.swift
//  Nordnet
//
//  Created by Valeriu POPA on 10/13/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import UIKit

/**
 Automatically localize title.
 */
class LocalizableBarButtonItem: UIBarButtonItem {

    override func awakeFromNib() {
        super.awakeFromNib()

        if let localizableText = self.title {
            self.title = localizableText.localized
        }
    }
}
