//
//  String+Localized.swift
//  Nordnet
//
//  Created by Valeriu POPA on 10/11/16.
//  Copyright © 2016 Nordnet. All rights reserved.
//

import Foundation

public extension String {
    /**
     - Brief: Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    var localized: String {

        let baseLanguage = "Base"
        var preferredLanguage = "en"
        if !Bundle.main.preferredLocalizations.isEmpty {
            preferredLanguage = Bundle.main.preferredLocalizations.first!
        }

        if let path = Bundle.main.path(forResource: preferredLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        } else if let path = Bundle.main.path(forResource: baseLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }

    /**
     - Brief: Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }

    /**
     - Brief: Swift 2 friendly plural localization syntax with a format argument
     - parameter argument: Argument to determine pluralisation
     - returns: Pluralized localized string.
     */
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized as NSString, argument) as String
    }
}
