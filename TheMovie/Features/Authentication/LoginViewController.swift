//
//  LoginViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/6/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Realm
import RealmSwift

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var emailLabel: UITextField!
    @IBOutlet private weak var passwordLabel: UITextField!
    @IBOutlet private weak var loginButton: TheMovieButton!
    @IBOutlet private weak var registerButton: TheMovieButton!
    
    private var viewModel : AuthentificationViewModel!
    private let loginDisposeBag = DisposeBag()
    static var index = 1
    
    // MARK: UI Lifecycle + Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.subscribe()
    }
    
    @IBAction func registerTapAction(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")
        self.navigationController?.pushViewController(registerViewController!, animated: true)
    }
    
    // MARK: Private methods
    private func setup() {
        self.viewModel = AuthentificationViewModel(userNameObservable: emailLabel.rx.text.asObservable(),
                                                   passwordObservable: passwordLabel.rx.text.asObservable())
    }
    
    private func subscribe() {
        
        let errorDisposable = self.viewModel.errorMessage.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (error) in
                UIAlertController.show(title: error, parent: self)
            })
        
        let loginSuccessDisposable = self.viewModel.loginSucceeded.asObserver()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let movieListViewController = UIStoryboard(name: "MovieList", bundle: Bundle.main).instantiateInitialViewController()
                self.present(movieListViewController!, animated: true, completion: nil)
            })
        
        let loginButtonActiveDisposable = self.viewModel.loginActionActive.bindTo(self.loginButton.rx.isEnabled)
        
        let loginActionDisposable = self.loginButton.rx.tap.asObservable().bindNext { [unowned self] in
            self.viewModel.loginAction(email: self.emailLabel.text!, password: self.passwordLabel.text!)
        }
        
        loginActionDisposable.addDisposableTo(loginDisposeBag)
        loginSuccessDisposable.addDisposableTo(loginDisposeBag)
        errorDisposable.addDisposableTo(loginDisposeBag)
        loginButtonActiveDisposable.addDisposableTo(loginDisposeBag)
    }
}

extension UIAlertController {
    class func show(title: String, parent controller: UIViewController) {
        let errorAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "dismiss", style: .default, handler: { (action) in
            errorAlert.dismiss(animated: true, completion: nil)
        })
        errorAlert.addAction(dismissAction)
        controller.present(errorAlert, animated: true)
    }
}
