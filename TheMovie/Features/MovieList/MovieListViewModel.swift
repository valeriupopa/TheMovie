    //
    //  MovieListViewModel.swift
    //  TheMovie
    //
    //  Created by Valeriu POPA on 3/27/17.
    //  Copyright © 2017 Valeriu POPA. All rights reserved.
    //
    
    import RxSwift
    
    class MovieListViewModel : MovieListBaseViewModel {
        
        // MARK: - Private properties
        private let api = API()
        private let disposeBag = DisposeBag()
        
        override init() {
            super.init()
            
            let movieObservable = api.getMovies()
            let genreObservable = api.getGenres()
            
            let movieZipObservable = Observable.zip(movieObservable, genreObservable) { (items: (movies: [Movie], genres: [Genre])) -> [Movie] in
                
                // extract genre names from genres and assign to movie
                items.movies.forEach({ (movie) in
                    movie.genres.forEach({ (movieGenre) in
                        
                        // search for gender with matching id
                        let genresOfMovie = items.genres.filter({ (genre) -> Bool in
                            movieGenre.id == genre.id
                        })
                        
                        // get the name of gender
                        if let gender = genresOfMovie.first {
                            movieGenre.name = gender.name
                        }
                    })
                })
                return items.movies
                }.bindTo(datasource)
            
            // add dispose bag
            movieZipObservable.addDisposableTo(disposeBag)
            
            let publish1 = PublishSubject<Int>()
            let publish2 = PublishSubject<Int>()
            let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
            let mainScheduler = MainScheduler.instance
            
            Observable.of(publish1,publish2)
                .observeOn(mainScheduler)
                .merge()
                .subscribeOn(mainScheduler)
                .subscribe(onNext:{
                    print($0)
                })
            publish1.onNext(20)
            publish2.onNext(30)
            publish1.onNext(40)
     
        }
    }
