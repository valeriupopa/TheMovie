//
//  MovieListSelectionInterpretable.swift
//  TheMovie
//
//  Created by Valeriu POPA on 3/27/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import RxSwift
import UIKit

protocol MovieListSelectionInterpretable {
    var datasource: Variable<[Movie]> { get set }
    var presentableViewController: PublishSubject<UIViewController> { get set }
}

class MovieListBaseViewModel : NSObject, MovieListSelectionInterpretable, UICollectionViewDelegate {

    // MARK: - Public properties
    var datasource: Variable<[Movie]> = Variable([])
    var presentableViewController: PublishSubject<UIViewController> = PublishSubject()

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let index = indexPath.row
        let detailsViewController = UIStoryboard(name: "MovieDetails", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController

        detailsViewController.movie = datasource.value[index]
        let detailsNavController = UINavigationController(rootViewController: detailsViewController)
        detailsNavController.isHeroEnabled = true

        presentableViewController.onNext(detailsNavController)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if UIDevice.current.model.contains("iPhone") {
            return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width * 0.57)
        } else {
            return CGSize(width: collectionView.bounds.size.width / 2 - 10, height: (collectionView.bounds.size.width / 2) * 0.57)
        }
    }
}
