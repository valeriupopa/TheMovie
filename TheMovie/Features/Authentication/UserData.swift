//
//  UserData.swift
//  TheMovie
//
//  Created by Valeriu POPA on 3/27/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import RealmSwift

let dateFormat : String = "yyyy-MM-dd"

class UserData: Object {
    dynamic var name: String = ""
    dynamic var email: String = ""
    dynamic var password: String = ""
    dynamic var birthday: Date = Date()
    dynamic var profile: String? = nil
    
    override static func primaryKey() -> String? {
        return "email"
    }
}
