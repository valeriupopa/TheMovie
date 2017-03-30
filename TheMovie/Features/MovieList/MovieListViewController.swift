//
//  MovieListViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/3/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Hero

class MovieListViewController : UIViewController {
   
    @IBOutlet private weak var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private let viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.subscribe()
    }
    
    // MARK: - Private methods
    private func setup() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.setIcon(iconName: "themovie")
        MovieCollectionViewCell.register(to: collectionView)
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView.delegate = self.viewModel
    }
    
    private func subscribe() {
        let movieListBindDisposable =  self.viewModel.datasource.asObservable().bindTo(collectionView.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
                return MovieCollectionViewCell()
            }
            let viewModel = MovieCollectioCellViewModel(movie: element)
            cell.viewModel = viewModel
            cell.configure(movie: element)
            
            return cell
        }
        
        let selectedMovieDisposable = self.viewModel.presentableViewController
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (viewController) in
                self?.present(viewController, animated: true, completion: nil)
            })
        
        selectedMovieDisposable.addDisposableTo(disposeBag)
        movieListBindDisposable.addDisposableTo(disposeBag)
    }
}
