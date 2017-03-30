//
//  GenreModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/6/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import SwiftyJSON

class Genre {
    let id : Int
    var name: String
    
    init?(json: JSON) {
        
        guard let id = json["id"].int else {
            return nil
        }
        self.id = id
        
        guard let name = json["name"].string else {
            return nil
        }
        self.name = name
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static func build(json: JSON) -> [Genre] {
        var genres = [Genre]()
        json.array?.forEach({ (genreJSON) in
            if let genre = Genre(json: genreJSON) {
                genres.append(genre)
            }
        })
        
        return genres
    }
}

extension Collection where Iterator.Element == Genre {
    
    func find(by id: Int) -> String? {
        
        let genreNames = self.filter { (genre) -> Bool in
            genre.id == id
            }.map { (genre) -> String in
                genre.name
        }
        
        return genreNames.first
    }
    
}
