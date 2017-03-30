//
//  LocalizableButton.swift
//  Nordnet
//
//  Created by Valeriu POPA on 10/13/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import UIKit

/**
 Automatically localize title.
 */
class LocalizableButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byWordWrapping

        UIView.performWithoutAnimation { [unowned self] in

            if let localizableText = self.titleLabel?.text {
                self.setTitle(localizableText.localized, for: .normal)
                self.layoutIfNeeded()
            }
        }
    }
}
