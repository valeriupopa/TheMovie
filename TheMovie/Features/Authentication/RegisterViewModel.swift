//
//  RegisterViewModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 3/24/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import RxSwift
import RealmSwift
import DateTimePicker

class RegisterViewModel {
    
    // MARK: - Public properties
    public let registerSucceeded : Observable<Void>
    public let validInputs = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Private properties
    private let birthDayObservable = PublishSubject<Date>()
    private let disposeBag = DisposeBag()
    
    private static let authentication = UserAuthentication()
    private static let datePickerColor = UIColor(hexString: "#1CD15E")
    
    init(data: RegisterViewDataModel) {
        
        let passwordObservable = Observable.combineLatest(data.passwordObservable, data.rePasswordObservable) { (password: String?, rePassword: String?) -> String in
            return password == rePassword ? password ?? "" : ""
        }
        
        let inputsObservable = Observable.combineLatest(passwordObservable, data.nameObservable, data.emailObservable, birthDayObservable) { (password: String, name: String?, email: String?, bd: Date) -> (String, String, String, Date) in
            return (password, name ?? "", email ?? "", bd)
        }
        
        let inputEnableDisposable = inputsObservable.map { (inputs:(password: String, name: String, email: String, bd: Date)) -> Bool in
            return !inputs.password.isEmpty && !inputs.name.isEmpty && !inputs.email.isEmpty
        }.bindTo(validInputs)
        
        registerSucceeded = data.registerActionObservable.withLatestFrom(inputsObservable)
            .map{ (cedentials: (password: String, name: String, email: String, bd: Date)) in
            return RegisterViewModel.authentication.register(name: cedentials.name, email: cedentials.email, password: cedentials.password, birthday: cedentials.bd)
        }
        
        // subscribe for bd selection action
        let bdDisposable = data.birthDaySelectionObservable
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos:.default))
            .subscribe(onNext: { [weak self] in
                let picker = DateTimePicker.show()
                picker.highlightColor = RegisterViewModel.datePickerColor
                
                picker.completionHandler = { [weak self] date in
                    self?.birthDayObservable.onNext(date)
                }
            })
        
        // add dispose bag
        bdDisposable.addDisposableTo(disposeBag)
        inputEnableDisposable.addDisposableTo(disposeBag)
    }
}
