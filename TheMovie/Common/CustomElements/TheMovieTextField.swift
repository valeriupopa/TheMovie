//
//  TheMovieTextField.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/6/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

@IBDesignable
class TheMovieTextField: LocalizableTextField {

    @IBInspectable var color: UIColor = UIColor(hexString: "#1CD15E") {
        didSet {
            self.layer.borderColor = color.cgColor
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: color])
            self.textColor = color
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = CGFloat(1)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
