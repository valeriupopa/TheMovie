//
//  FavoriteListViewModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 3/27/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class FavoriteListViewModel : MovieListBaseViewModel, MovieCollectionViewCellDelegate {

    // MARK: - Private properties
    private let api = API()
    private let disposeBag = DisposeBag()

    override init() {
        super.init()

        let movieObservable = api.getMovies()
        let genreObservable = api.getGenres()

        _ = Observable.combineLatest(genreObservable, movieObservable, resultSelector: { (genres, movies) -> [Movie] in
            // extract genre names from genres and assign to movie

            // get all favorite movies
            let realm = try! Realm()
            let favoriteMovieIDs = realm.objects(FavoriteMovie.self)

            movies.forEach({ (movie) in
                movie.genres.forEach({ (movieGenre) in

                    // search for gender with matching id
                    let genresOfMovie = genres.filter({ (genre) -> Bool in
                        movieGenre.id == genre.id
                    })

                    // get the name of gender
                    if let gender = genresOfMovie.first {
                        movieGenre.name = gender.name
                    }
                })

                for fmovie in favoriteMovieIDs {
                    if movie.id == fmovie.id {
                        movie.favorite = true
                    }
                }
            })

            return movies
        }).reduce([], accumulator: { (result, movies) -> [Movie] in
            return movies.filter({ (movie) -> Bool in
                movie.favorite
            })
        }).bindTo(datasource)
    }

    func didChangeFavoriteStatus(movie: Movie) {
        guard let index = self.datasource.value.index(where: { (movieItem) -> Bool in movie.id == movieItem.id }) else {
            return
        }

        self.datasource.value.remove(at: index)
    }
}
