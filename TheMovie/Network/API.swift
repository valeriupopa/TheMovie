//
//  API.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/4/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift
import SwiftyJSON

class API {
    
    private static let baseURLString = "https://api.themoviedb.org"
    private static let apiKey = "2652f9a822573315e3a1f18a6d031384"
    static let imagePath = "https://image.tmdb.org/t/p/w500"
    static let googleMapKey = "AIzaSyB9z-vRfVfAcoTpycJZQt1Dh-n5rrsh67c"
    
    // Get movie from api endpoint.
    func getMovies() -> Observable<[Movie]> {
        
        let sourceStringURL = "\(API.baseURLString)/3/movie/popular?api_key=\(API.apiKey)&language=en-US&page=1"
        let movieObservable = Observable<[Movie]>.create { (observer) -> Disposable in
            let requestDisposable = requestJSON(.get, sourceStringURL)
                .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
                .subscribe(onNext: { (response, json) in
                    
                    // Extract information from json and generate a new signal into stream.
                    observer.onNext(Movie.build(json: JSON(json)["results"]))
                    
                    // mark observable stream as done.
                    observer.onCompleted()
                    
                }, onError: { (error) in
                    // Send empty array of movies
                    observer.onError(error)
                })
            
            return Disposables.create {
                requestDisposable.dispose()
            }
            
        }.observeOn(MainScheduler.instance)
        
        return movieObservable
    }
    
    func getGenres() -> Observable<[Genre]> {
        let genreStringURL = "\(API.baseURLString)/3/genre/movie/list?api_key=\(API.apiKey)&language=en-US&page=1"
        let genreObservable = Observable<[Genre]>.create { (observer) -> Disposable in
            let disposableBag = requestJSON(.get, genreStringURL)
                .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
                .subscribe(onNext: { (response, json) in
                    
                    // Extract information from json and generate a new signal into stream.
                    observer.onNext(Genre.build(json: JSON(json)["genres"]))
                    
                    // mark observable stream as done.
                    observer.onCompleted()
                    
                }, onError: { (error) in
                    // Send empty array of movies
                    observer.onError(error)
                })
            
            return Disposables.create {
                disposableBag.dispose()
            }
            
        }.subscribeOn(MainScheduler.instance)
        
        return genreObservable
    }
    
    func getCredits(movieID: Int) -> (Observable<[Cast]>, Observable<[Crew]>) {
        let creditStringURL = "\(API.baseURLString)/3/movie/\(movieID)/credits?api_key=\(API.apiKey)&language=en-US&page=1"
        
        let crewSubject = PublishSubject<[Crew]>()
        let creditSubject = PublishSubject<[Cast]>()
        
        _ = requestJSON(.get, creditStringURL)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .subscribe(onNext: { (response, json) in
                
                // Extract information from json and generate a new signal into stream.
                creditSubject.onNext(Cast.build(json: JSON(json)["cast"]))
                crewSubject.onNext(Crew.build(json: JSON(json)["crew"]))
                
                // mark observable stream as done.
                creditSubject.onCompleted()
                crewSubject.onCompleted()
            }, onError: { (error) in
                // Send empty array of movies
                creditSubject.onError(error)
                crewSubject.onError(error)
        })
        
        return (creditSubject, crewSubject)
    }
    
    func getPopularActors() -> Observable<[Actor]> {
        let actorStringURL = "\(API.baseURLString)/3/person/popular?api_key=\(API.apiKey)&language=en-US&page=1"
        let actorObservable = Observable<[Actor]>.create { (observer) -> Disposable in
            _ = RxAlamofire.requestJSON(.get, actorStringURL)
                .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
                .subscribe(onNext: { (response, json) in
                    // Extract information from json and generate a new signal into stream.
                    observer.onNext(Actor.build(json: JSON(json)["results"]))
                    
                    // mark observable stream as done.
                    observer.onCompleted()
                }, onError: { (error) in
                    // Send empty array of movies
                    observer.onError(error)
                })
            
            return Disposables.create()
        }

        return actorObservable
    }
    
    class func login(params: [String: Any], callBack success: (_ response: APIResponse)->Void) {
    
    }
}

