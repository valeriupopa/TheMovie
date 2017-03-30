//
//  MovieCollectionViewCell.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/3/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import AlamofireImage
import Realm
import RealmSwift
import RxSwift

protocol UICustomCellRegister {
    static var identifier: String { get set }
}

protocol MovieCollectionViewCellDelegate {
    func didChangeFavoriteStatus(movie: Movie)
}

class MovieCollectionViewCell: UICollectionViewCell, UICustomCellRegister{

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    static var identifier: String = "MovieCollectionViewCell"

    var viewModel: MovieCollectioCellViewModel!
    var delegate: MovieCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.heroID = "movie_poster"
    }
    
    public func configure(movie: Movie) {
        
        self.viewModel = MovieCollectioCellViewModel(movie: movie)
        
        titleLabel.text = movie.title
        details.text = movie.overview
        
        if let posterURL = movie.posterPath {
            posterImageView.af_setImage(withURL: posterURL)
        }
        
        let genreTitles = movie.genres.map { (genre) -> String in
            return genre.name
            }.reduce("", { (genreTitles, genreName) in
                "\(genreName), \(genreTitles)"
        })
        
        if let releasedDate = movie.releaseDate {
            let calendar = NSCalendar.current
            self.calendarLabel.text = "\(calendar.component(Calendar.Component.year, from: releasedDate))"
        }
        
        let tt = genreTitles.substring(to: genreTitles.index(genreTitles.endIndex, offsetBy: -2))
        
        typesLabel.text = tt
        
        _ = self.viewModel.favoriteButtonImage.asObservable()
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] (image) in
            self.favoriteButton.setImage(image, for: .normal)
        })
        
        self.starLabel.text = String(movie.voteAverage)
        
        self.viewModel.updateFavoriteStatus()
    }
    
    // MARK: - Actions
    
    @IBAction func markFavoritesTapAction(_ sender: Any) {
        self.viewModel.changeFavoriteStatus()
    
        if let `delegate` = self.delegate {
            delegate.didChangeFavoriteStatus(movie: self.viewModel.movie)
        }
    }
}

class MovieCollectioCellViewModel {
    
    // MARK: - Properties
    public let movie: Movie
    public let favoriteButtonImage = PublishSubject<UIImage?>()
    public let popularity = PublishSubject<Double>()
    private let realm = try! Realm()
    
    // MARK: - Public methods
    init(movie: Movie) {
        self.movie = movie
        self.popularity.onNext(movie.voteAverage)
    }
    
    func changeFavoriteStatus() {
        if let favoriteMovie = self.realm.objects(FavoriteMovie.self).filter("id == \(self.movie.id)").first {
            
            // Remove it
            try! self.realm.write {
                self.realm.delete(favoriteMovie)
            }
            self.updateFavoriteStatus()
            
        } else {
            // Create and save movie id
            let favoriteMovie = FavoriteMovie()
            favoriteMovie.id = self.movie.id
            
            try! self.realm.write {
                self.realm.add(favoriteMovie)
            }
            self.updateFavoriteStatus()
        }
    }
    
    func updateFavoriteStatus() {
     
        if self.realm.objects(FavoriteMovie.self).filter("id == \(self.movie.id)").first != nil {
            self.movie.favorite = true
            self.favoriteButtonImage.onNext(UIImage(named: "favoritesSelected"))
        } else {
            self.movie.favorite = false
            self.favoriteButtonImage.onNext(UIImage(named: "favoritesDiselected"))
        }
    }
}

class FavoriteMovie: Object {
    dynamic var id: Int = 0
}
