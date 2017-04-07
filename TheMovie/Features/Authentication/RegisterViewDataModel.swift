//
//  RegisterViewDataModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 3/27/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import RxSwift

class RegisterViewDataModel {
    let nameObservable: Observable<String?>
    let emailObservable: Observable<String?>
    let passwordObservable: Observable<String?>
    let rePasswordObservable: Observable<String?>
    let registerActionObservable: Observable<Void>
    let birthDaySelectionObservable: Observable<Void>

    init(name: Observable<String?>, email emailRx: Observable<String?>,
         password pwRx: Observable<String?>, rePassword rePwRx: Observable<String?>,
         registerAction regRx: Observable<Void>, birthdayAction bdRx: Observable<Void>) {

        nameObservable = name
        emailObservable = emailRx
        passwordObservable = pwRx
        rePasswordObservable = rePwRx
        birthDaySelectionObservable = bdRx
        registerActionObservable = regRx
    }
}
