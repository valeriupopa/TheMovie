////
////  DemoCodeExamples.swift
////  TheMovie
////
////  Created by Valeriu POPA on 4/5/17.
////  Copyright © 2017 Valeriu POPA. All rights reserved.
////
//
//import RxSwift
//import RxCocoa
//import UIKit
//
//enum APIResponse {
//    case success(String)
//    case failure(NSError)
//}
//
//class LoginController : UIViewController {
//    @IBOutlet private weak var emailTextField: UITextField!
//    @IBOutlet private weak var passwordTextField: UITextField!
//    @IBOutlet weak var loginButton: TheMovieButton!
//    
//    var viewModel : LoginViewModel!
//    let disposeBag = DisposeBag()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        viewModel = LoginViewModel(username: emailTextField.rx.text.asObservable(),
//                                   password: passwordTextField.rx.text.asObservable())
//        let loginValidation = viewModel.isValid.bindTo(loginButton.rx.isEnabled)
//        loginValidation.addDisposableTo(disposeBag)
//    }
//}
//
//struct LoginViewModel {
//    let password : Observable<String>
//    let username : Observable<String>
//    let isValid : Observable<Bool>
//    
//    init(username usernameRx: Observable<String?>, password passwordRx: Observable<String?>) {
//        username =  usernameRx.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .filter(LoginViewModel.inputNilFilter)
//            .map(LoginViewModel.inputMap)
//            .observeOn(MainScheduler.instance)
//        
//        password =  passwordRx.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .filter(LoginViewModel.inputNilFilter)
//            .map(LoginViewModel.inputMap)
//            .observeOn(MainScheduler.instance)
//        
//        isValid = Observable.combineLatest(username, password) { (usernameText, passwordText) in
//            return !usernameText.isEmpty && !passwordText.isEmpty
//        }
//    }
//    
//    private static func inputNilFilter(_ text: String?) -> Bool {
//        return text != nil
//    }
//    
//    private static func inputMap(_ text: String?) -> String {
//        return text!
//    }
//}
//
//enum AuthenticateResponse {
//    case success(String)
//    case error(String)
//    case unknown
//}
//
//enum AuthenticateError: Error {
//    case badCredentials
//    case sessionExpired
//    case anyOtherErrorType
//}
//
//protocol UserCredentials {
//    var username: String { get set }
//    var password: String { get set }
//}
//
//protocol Registable: UserCredentials {
//    func register(birthDate bd: Date) -> Observable<User>
//}
//
//protocol Authenticateable: UserCredentials{
//    func login() -> Observable<AuthenticateResponse>
//}
//
//extension Registable {
//    func register(birthDate bd: Date) -> Observable<User> {
//        return Observable<User>.create { (observer) -> Disposable in
//            
//            // try to register if succeeded then generate next event
////            observer.onNext(User())
//            // otherwise generate error event
////            observer.onError(Error)
//            observer.onCompleted()
//            
//            return Disposables.create()
//        }
//    }
//}
//
//extension Authenticateable {
//    func login() -> Observable<AuthenticateResponse> {
//        return Observable.create({ (observer) -> Disposable in
//            
//            // if login succeded
//            observer.onNext(AuthenticateResponse.success("Eee... you've logged in"))
//            
//            // if failed
//            observer.onNext(AuthenticateResponse.error("Hmm... something went wrong"))
//            
//            // or send an error event and terminate the stream
//            observer.onError(AuthenticateError.badCredentials)
//            
//            observer.onCompleted()
//            
//            return Disposables.create()
//        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//        .observeOn(MainScheduler.instance)
//    }
//}
//
//struct SignInViewModel: Authenticateable, Registable {
//    var username: String = ""
//    var password: String = ""
//}
//
//class SomeController {
//    func test() {
//        let viewModel = SignInViewModel()
//        viewModel.login().observeOn(MainScheduler.instance).subscribe(onNext: { (response) in
//            // do what you want with the response :)
//        })
//    }
//}
