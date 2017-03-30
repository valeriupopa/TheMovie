//
//  LocalizableTextField.swift
//  Nordnet
//
//  Created by Valeriu POPA on 10/13/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import UIKit

/**
 Automatically localize placeholder.
 */
open class LocalizableTextField: UITextField {

    open override func awakeFromNib() {
        super.awakeFromNib()

        if let localizablePlaceholder = self.placeholder {
            self.placeholder = localizablePlaceholder.localized
        }
    }
}
