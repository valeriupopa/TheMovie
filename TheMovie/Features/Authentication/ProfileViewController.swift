//
//  ProfileViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/13/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import DateTimePicker
import RxSwift
import RxCocoa
import Realm

class ProfileViewController: UIViewController {
   
    // MARK: - Properties
    @IBOutlet weak var profileAvatarImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UITextField!
    @IBOutlet weak var birthdayButton: TheMovieButton!
    @IBOutlet weak var updateButton: TheMovieButton!
    @IBOutlet weak var avatarButton: RoundedButton!
    
    private var selectedBirthday: Date!
    private let user: User = User.shared
    private var datetimePicker: DateTimePicker?
    private let photoPicker = PhotoPickerViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setIcon(iconName: "themovie")
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.subscribeForPhoto()
        self.initUIComponets()
        self.subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        user.renewPhoto(url: user.profile.value)
    }
    
    // MARK: - UI Actions
    
    @IBAction func datetimePickerDismissAction(_ sender: Any) {
//        guard let picker = self.datetimePicker else { return }
        
//        picker.removeFromSuperview()
    }
    
    
    // MARK: - Private methods
    private func subscribe() {
        
        _ = self.avatarButton.rx.tap.asObservable()
        .subscribe(onNext: { [unowned self] in
            self.photoPicker.showPicker()
        })
        
        _ = self.birthdayButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] in
                
                self.datetimePicker = DateTimePicker.show(selected: self.user.birthdate.value, minimumDate: nil, maximumDate: nil)
                self.datetimePicker!.highlightColor = UIColor(hexString: "#1CD15E")
                
                self.datetimePicker!.completionHandler = { date in
                    self.selectedBirthday = date
                }
            })
        
        _ = self.avatarButton.rx.tap.asObservable()
        .subscribe(onNext: { [unowned self] in
            self.update()
        })
        
        _ = nameLabel.rx.text.asObservable()
            .subscribe(onNext: { [unowned self] (text) in
                guard let `text` = text else { return }
                
                self.user.name = Variable(text)
            })
        
        _ = emailLabel.rx.text.asObservable()
            .subscribe(onNext: { [unowned self] (text) in
                guard let `text` = text else { return }
                
                self.user.email = Variable(text)
            })
        
        let passwordObservable = Observable.combineLatest(passwordLabel.rx.text, repeatPasswordLabel.rx.text) { (password: String?, repeatPassword: String?) -> String? in
            
            guard let password = password, let `repeatPassword` = repeatPassword else { return nil }
        
            return password == repeatPassword ? password : nil
        }.filter { (text) -> Bool in text != nil }
        
        let passwordMatchObservable = passwordObservable.map { (text) -> Bool in text != nil }
        
        _ = passwordObservable.map({ (text) -> String in text! })
        .bindTo(user.password)
        
        let nameTextObservable = nameLabel.rx.text.asObservable()
        .filter { (text) -> Bool in text != nil }
        .map { $0! }
        
        _ = nameTextObservable.bindTo(user.name)
        let nameValidationObservable = nameTextObservable.map { (password) -> Bool in true }
        
        _ = Observable.combineLatest(passwordMatchObservable, nameValidationObservable) { (password :Bool, name: Bool) -> Bool in
            return password && name
        }.bindTo(updateButton.rx.isEnabled)
        
        _ = updateButton.rx.tap.asObservable()
        .subscribe(onNext: { [unowned self] in
            self.update()
        })
    }
    
    
    private func initUIComponets() {
        
        _ = user.photo.asObservable()
            .subscribeOn(MainScheduler.instance)
            .bindTo(self.profileAvatarImageView.rx.image)
        
        _ = user.name.asObservable().bindTo(nameLabel.rx.text)
        _ = user.email.asObservable().bindTo(emailLabel.rx.text)
        _ = user.password.asObservable().bindTo(passwordLabel.rx.text)
        _ = user.password.asObservable().bindTo(repeatPasswordLabel.rx.text)
       
    }
    
    private func subscribeForPhoto() {
        _ = self.photoPicker.present.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (viewController) in
                self.present(viewController, animated: true, completion: nil)
            })
        
        _ = self.photoPicker.didGetImageURL.asObservable()
            .bindTo(User.shared.profile)
        
        _ = self.photoPicker.didGetImageURL.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { (url) in
                User.shared.update()
            })
    }
    
    private func update() {
        self.user.update()
        
        let infoAlert = UIAlertController(title: "User info updated!", message: nil, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "dismiss", style: .default, handler:{ [unowned infoAlert] (action) in
            infoAlert.dismiss(animated: true, completion: nil)
        })
        infoAlert.addAction(doneAction)
        
        self.present(infoAlert, animated: true, completion: nil)
        
    }

}
