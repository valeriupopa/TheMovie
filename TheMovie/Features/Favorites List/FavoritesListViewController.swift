//
//  FavoritesListViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/13/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class FavoritesListViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    private let movieDisposeBag = DisposeBag()
    private let viewModel = FavoriteListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.subscribe()
    }

    // MARK: - Private methods
    private func setup() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

        setIcon(iconName: "themovie")
        MovieCollectionViewCell.register(to: collectionView)
        automaticallyAdjustsScrollViewInsets = false
        self.collectionView.delegate = self.viewModel
    }

    private func subscribe() {
        let dataSourceBindDisposable = self.viewModel.datasource.asObservable().bindTo(collectionView.rx.items) { [unowned self] (collectionView, row, element) in

            let indexPath = IndexPath(row: row, section: 0)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
                return MovieCollectionViewCell()
            }

            let viewModel = MovieCollectioCellViewModel(movie: element)
            cell.viewModel = viewModel
            cell.configure(movie: element)
            cell.delegate = self.viewModel

            return cell
        }

        dataSourceBindDisposable.addDisposableTo(movieDisposeBag)
    }
}
