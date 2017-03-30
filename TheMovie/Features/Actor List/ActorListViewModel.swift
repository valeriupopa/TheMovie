//
//  ActorListViewModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/11/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import RxSwift


class ActorListViewModel {

    var actors: Variable<[Actor]> = Variable([])
    private let api = API()
    private let actorDisposeBag = DisposeBag()
    
    init() {
        _ = api.getPopularActors()
        .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        .bindTo(actors)
        .addDisposableTo(actorDisposeBag)
    }
}
