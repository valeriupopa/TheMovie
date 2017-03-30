//
//  MovieModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/5/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class Movie {
    
    let aduld: Bool
    let id: Int
    let backdropPath: URL?
    var genres : [Genre] = []
    let originalLanguage: Language
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: URL?
    let releaseDate: Date?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var favorite: Bool
    
    init?(json: JSON) {
        
        self.aduld = json["adult"].boolValue
        
        guard let id = json["id"].int else {
            return nil
        }
        self.id = id
        
        self.backdropPath = URL(string: API.imagePath + json["backdrop_path"].stringValue)
        
        self.originalLanguage = Language(rawValue: json["original_language"].stringValue) ?? Language.en
        
        guard let originalTitle = json["original_title"].string else {
            return nil
        }
        self.originalTitle = originalTitle
        
        guard let overview = json["overview"].string else {
            return nil
        }
        self.overview = overview
        self.popularity = json["popularity"].doubleValue
        self.voteCount = json["vote_count"].intValue
        self.posterPath = URL(string: API.imagePath + json["poster_path"].stringValue)
    
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        self.releaseDate = dateFormater.date(from: json["release_date"].stringValue)
      
        guard let title = json["title"].string else {
            return nil
        }
        self.title = title
        self.video = json["video"].boolValue
        self.voteAverage = json["vote_average"].doubleValue
        
        let genreJSONIDs = json["genre_ids"].arrayValue
        for genreJSON in genreJSONIDs {
            genres.append(Genre(id: genreJSON.intValue, name: ""))
        }
        
        self.favorite = false
    }
    
    // Extract movie from json received from api.
    static func build(json: JSON) -> [Movie] {
        var movieList = [Movie]()
        json.array?.forEach({ (jsonElement) in
            if let movie = Movie(json: jsonElement) {
                movieList.append(movie)
            }
        })
        return movieList
    }
}

enum Language : String {
    case en = "en"
    case fr = "fr"
}
