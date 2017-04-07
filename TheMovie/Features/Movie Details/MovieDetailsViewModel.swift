//
//  MovieDetailsViewModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/9/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import RxSwift

class MovieDetailsViewModel {
    var overview: Variable<String>
    var posterURL: Variable<URL?>
    var credits: Variable<[Cast]> = Variable([])
    var crew: Variable<[Crew]> = Variable([])

    private let api = API()
    private let creditsDisposeBag = DisposeBag()

    init(movie: Movie) {

        self.overview = Variable(movie.overview)
        self.posterURL = Variable(movie.posterPath)

        let creditAndCrewObservable = api.getCredits(movieID: movie.id)
        let creditObservable = creditAndCrewObservable.0
        let crewObservable = creditAndCrewObservable.1

        creditObservable.bindTo(credits).addDisposableTo(creditsDisposeBag)
        crewObservable.bindTo(crew).addDisposableTo(creditsDisposeBag)
    }
}
