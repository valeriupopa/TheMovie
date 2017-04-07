//
//  ContainerViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/13/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import RxSwift

class ContainerViewController: SlideMenuController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var navigation: UINavigationController! {
        didSet {
            navigation.navigationBar.barTintColor = UIColor(hexString: "060B20")
        }
    }

    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigation = UINavigationController(rootViewController: Screen.movies.viewController)
        self.mainViewController = navigation

        if let sideMenuController = Screen.sideMenu.viewController as? SideMenuViewController {
            sideMenuController.selectedViewController.subscribeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] (viewController) in
                    self.navigation.setViewControllers([viewController], animated: true)
                    self.closeLeft()
                }).addDisposableTo(disposeBag)

            self.leftViewController = sideMenuController
        }
    }
}
