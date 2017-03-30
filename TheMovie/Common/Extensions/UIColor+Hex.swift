//
//  UIColor+Hex.swift
//  Nordnet
//
//  Created by Valeriu POPA on 10/11/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import UIKit

extension UIColor {
    /*
     - Brief: Constructs a new UIColor from hexadecimal String and alpha value.
     */
    convenience init(hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }

    /*
     - Brief: Constructs a new UIColor from hexadecimal number and alpha value.
     */
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    // Return an image from color. Fill a rectacngle with color.
    var image: UIImage? {

        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)

        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setFillColor(self.cgColor)
        context.fill(rect)

        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return colorImage
    }
}
