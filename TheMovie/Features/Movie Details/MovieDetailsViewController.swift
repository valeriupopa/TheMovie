//
//  MovieDetailsViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/9/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet fileprivate weak var featuredCrewCollectionView: UICollectionView!{
        didSet {
            MovieCrewCollectionViewCell.register(to: featuredCrewCollectionView)
        }
    }
    @IBOutlet private weak var featuredCrewHeightContraint: NSLayoutConstraint!
    @IBOutlet private weak var topBilledCollectionView: UICollectionView! {
        didSet {
            MovieActorCollectionViewCell.register(to: topBilledCollectionView)
        }
    }
    @IBOutlet private weak var topBilledHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var overviewLabel: UILabel!

    var movie: Movie! {
        didSet {
            viewModel = MovieDetailsViewModel(movie: movie)
        }
    }
    
    internal var viewModel: MovieDetailsViewModel!
    internal let movieDisposeBad = DisposeBag()
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHeroEnabled = true
        
        self.view.heroID = "movie_poster"
        self.view.heroModifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]
        
        self.subscribe()
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.featuredCrewCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        self.topBilledCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.featuredCrewCollectionView.removeObserver(self, forKeyPath: "contentSize")
        self.topBilledCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView {
            
            var heightContraint: NSLayoutConstraint!
            switch observedObject {
            case self.featuredCrewCollectionView:
                heightContraint = self.featuredCrewHeightContraint
                break
            default:
                heightContraint = topBilledHeightConstraint
                break
            }
            
            UIView.animate(withDuration: 0.8, animations: {
                    heightContraint.constant = observedObject.contentSize.height
            })
        }
    }
    
    @IBAction func backTapAction(_ sender: Any) {
//        _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func configure() {
        self.title = self.movie.title
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#060B20")
    }
    
    private func subscribe() {
        
        // Bind overview to label
        _ = viewModel.overview.asObservable()
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] (overview) in
            self.overviewLabel.text = overview
        })
        .addDisposableTo(movieDisposeBad)
        
        // Bind poster URL to image view
        _ = viewModel.posterURL.asObservable()
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] (posterURL) in
            if let url = posterURL {
                self.posterImageView.af_setImage(withURL: url)
            }
        })
        .addDisposableTo(movieDisposeBad)
        
        // Bind cast members to collection view
        _ = viewModel.credits.asObservable()
        .bindTo(topBilledCollectionView.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieActorCollectionViewCell.identifier, for: indexPath) as? MovieActorCollectionViewCell else {
                return MovieActorCollectionViewCell()
            }
            
            cell.configure(cast: element)
            
            return cell
        }.addDisposableTo(movieDisposeBad)
        
        // Bind crew members to collection view
        _ = viewModel.crew.asObservable()
            .bindTo(featuredCrewCollectionView.rx.items) { (collectionView, row, element) in
        
            let indexPath = IndexPath(row: row, section: 0)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCrewCollectionViewCell.identifier, for: indexPath) as? MovieCrewCollectionViewCell else {
                return MovieCrewCollectionViewCell()
            }
            
            cell.configure(crew: element)
            
            return cell
        }.addDisposableTo(movieDisposeBad)
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case featuredCrewCollectionView:
            let crewMember = self.viewModel.crew.value[indexPath.row]
            print(crewMember.name)
            break
        default:
            let cast = self.viewModel.credits.value[indexPath.row]
            print(cast.name)
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch collectionView {
        case featuredCrewCollectionView:
            return CGSize(width: collectionView.bounds.size.width / 2 - 4, height: 50)
        default:
            return CGSize(width: collectionView.bounds.size.width / 3 - 8, height: collectionView.bounds.size.width / 2 - 8)
        }
    }
}













