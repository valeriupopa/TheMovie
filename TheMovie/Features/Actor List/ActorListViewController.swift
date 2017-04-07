//
//  ActorListViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/11/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ActorListViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            ActorCollectionViewCell.register(to: collectionView)
        }
    }
    private let viewModel = ActorListViewModel()
    private let actorListDisposeBag = DisposeBag()

    // MARK: UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setIcon(iconName: "themovie")
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false

        self.subscribe()
    }

    // MARK: Private methods
    private func subscribe() {  
        _ = viewModel.actors.asObservable()
            .bindTo(collectionView.rx.items) { (collection, row, actor) in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: ActorCollectionViewCell.identifier, for: indexPath) as? ActorCollectionViewCell else {
                    return ActorCollectionViewCell()
                }

                cell.configure(actor: actor)

                return cell
        }
    }
}

extension ActorListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if UIDevice.current.model.contains("iPhone") {
            return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width * 0.52)
        } else {
            return CGSize(width: collectionView.bounds.size.width / 2 - 10, height: (collectionView.bounds.size.width / 2) * 0.52)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print(indexPath)
    }
}
