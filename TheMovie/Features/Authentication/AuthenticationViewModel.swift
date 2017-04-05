//
//  AuthenticationViewModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/12/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

class AuthenticationViewModel {
    
    // MARK: Public properties
    public var errorMessage = PublishSubject<String>()
    public var loginSucceeded = PublishSubject<Void>()
    public var loginActionActive = BehaviorSubject<Bool>(value: false)
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private let authentication = UserAuthentication()
    
    init(userNameObservable: Observable<String?>, passwordObservable passwordRX: Observable<String?>) {
        
        let emailValidation = userNameObservable.map({ (text) -> Bool in
            // do some additional validations
            !(text?.isEmpty ?? true)
        })
        
        let passwordValidation = passwordRX.map({ (text) -> Bool in
            // do additional validations
            !(text?.isEmpty ?? true)
        })
        
        let enableLoginDisposable = Observable.combineLatest(emailValidation, passwordValidation) {(email, password) in
            return email && password
        }.bindTo(loginActionActive)
        
        // add disposable bag
        enableLoginDisposable.addDisposableTo(disposeBag)
    }
    
    public func loginAction(email: String, password: String) {
        guard let _ = authentication.loginAction(email: email, password: password) else {
            errorMessage.onNext("No user found!")
            return
        }
        
        loginSucceeded.onNext()
    }
}
