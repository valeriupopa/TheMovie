//
//  UserAuthentication.swift
//  TheMovie
//
//  Created by Valeriu POPA on 3/27/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import RealmSwift

class UserAuthentication {
    public func register(name: String, email: String, password: String, birthday: Date) {

        let user = UserData()
        user.name = name
        user.email = email
        user.password = password
        user.birthday = birthday

        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }

        if let theUser = realm.objects(UserData.self).filter("name == '\(name)'").first {
            User.shared = User(userData: theUser)
        }
    }

    @discardableResult
    public func loginAction(email: String, password: String) -> User? {

        let realm = try! Realm()
        let users = realm.objects(UserData.self).filter("email == '\(email)' AND password == '\(password)'")

        if let user = users.first {
            User.shared = User(userData: user)
            return User.shared
        }

        return nil
    }
}
