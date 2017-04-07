//
//  RegisterViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/11/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import RxSwift
import RxCocoa
import Photos
import DateTimePicker

class RegisterViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var registerButton: TheMovieButton!
    @IBOutlet private weak var birthdayButton: TheMovieButton!

    private let registerDisposeBag = DisposeBag()
    private var viewModel : RegisterViewModel!

    // MARK: - UI lifecycle + Actions
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.subscribe()
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Private methods
    private func setup() {
        let registerViewData = RegisterViewDataModel(name: nameTextField.rx.text.asObservable(),
                                                    email: emailTextField.rx.text.asObservable(),
                                                 password: passwordTextField.rx.text.asObservable(),
                                               rePassword: confirmPasswordTextField.rx.text.asObservable(),
                                           registerAction: registerButton.rx.tap.asObservable(),
                                           birthdayAction: birthdayButton.rx.tap.asObservable())

        self.viewModel = RegisterViewModel(data: registerViewData)
    }

    private func subscribe() {
        self.viewModel.registerSucceeded.subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] in
            _ = self.navigationController?.popViewController(animated: true)
        }).addDisposableTo(registerDisposeBag)

        self.viewModel.validInputs.bindTo(self.registerButton.rx.isEnabled)
        .addDisposableTo(registerDisposeBag)
    }
}
