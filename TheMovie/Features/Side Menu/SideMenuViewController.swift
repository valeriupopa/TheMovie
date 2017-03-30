//
//  SideMenuViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/11/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Photos

class SideMenuViewController: UIViewController, UITableViewDelegate{
    
    // MARK: - Properties
    private let viewModel = SideMenuViewModel()
    private let sideMenuDisposeBag = DisposeBag()
    private let photoPicker = PhotoPickerViewModel()
    var selectedViewController = PublishSubject<UIViewController>()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            SideMenuTableViewCell.register(to: tableView)
            tableView.tableFooterView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
        }
    }
    
    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var avatarPhotoButton: RoundedButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subscribeForPhoto()
        self.subscribe()
        User.shared.renewPhoto(url: User.shared.profile.value)
    }
    
    @IBAction func changeAvatarTapAction(_ sender: Any) {
        self.photoPicker.showPicker()
    }
    
    // MARK: - Private methods
    private func subscribe() {
        _ = viewModel.menuItems.asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: SideMenuTableViewCell.identifier)) {index, model, cell in
                if let sideMenuCell = cell as? SideMenuTableViewCell {
                    sideMenuCell.configure(data: model)
                }
            }.addDisposableTo(sideMenuDisposeBag)
        
        _ = tableView.rx.itemSelected.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (indexPath) in
                self.viewModel.sideMenuAction(for: indexPath.row)
            })

        _ = User.shared.name.asObservable()
        .subscribeOn(MainScheduler.instance)
        .bindTo(self.usernameLabel.rx.text)
        
        _ = User.shared.email.asObservable()
        .subscribeOn(MainScheduler.instance)
        .bindTo(self.userEmailLabel.rx.text)
        
        _ = User.shared.photo.asObservable()
        .subscribeOn(MainScheduler.instance)
        .bindTo(self.profileImageView.rx.image)
        
        _ = viewModel.viewController.bindTo(selectedViewController)
        
        _ = selectedViewController.subscribe(onNext: { (viewController) in
            print(viewController)
        })
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
}
