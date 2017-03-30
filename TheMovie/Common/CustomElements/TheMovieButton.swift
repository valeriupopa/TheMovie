//
//  TheMovieButton.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/6/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

@IBDesignable
class TheMovieButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = CGFloat(1)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor(hexString: "#1CD15E") {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var titleColor: UIColor = UIColor.white {
        didSet {
            self.setTitleColor(titleColor, for: .normal)
            self.setTitleColor(titleColor, for: .selected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
