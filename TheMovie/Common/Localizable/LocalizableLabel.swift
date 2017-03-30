//
//  LocalizableLabel.swift
//  Nordnet
//
//  Created by Valeriu POPA on 10/13/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import UIKit

/**
 Automatically localize text.
 */
@IBDesignable
class LocalizableLabel: UILabel {

    @IBInspectable
    var upperCase: Bool = false {
        didSet {
            if let localizableText = self.text {
                self.text = upperCase ? localizableText.localized.uppercased() : localizableText.localized
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0

        if let localizableText = self.text {
            self.text = upperCase ? localizableText.localized.uppercased() : localizableText.localized
        }
    }
}
