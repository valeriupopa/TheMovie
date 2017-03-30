//
//  LocalizableTextView.swift
//  Nordnet
//
//  Created by Valeriu POPA on 10/13/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import UIKit

/**
 Automatically localize text.
 */
class LocalizableTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()

        if let localizableText = self.text {
            self.text = localizableText.localized
        }
    }
}
