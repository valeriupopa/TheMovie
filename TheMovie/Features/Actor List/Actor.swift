//
//  Actor.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/11/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Actor: JSONObjectInitialization {
    let profilePath: URL?
    let adult: Bool
    let id: Int
    let name: String
    let popularity: Double
    let knownFor: [Movie]

    var info: String {
        return self.knownFor.reduce("", { (result, movie) -> String in
            "\(result)\(movie.title)\n"
        })
    }

    init?(json: JSON) {
        self.profilePath = URL(string: API.imagePath + json["profile_path"].stringValue)
        self.adult = json["adult"].boolValue
        guard let id = json["id"].int else {
            return nil
        }
        self.id = id
        self.knownFor = Movie.build(json: json["known_for"])
        self.name = json["name"].stringValue
        self.popularity = json["popularity"].doubleValue
    }

    public static func build(json: JSON) -> [Actor] {
        var actors = [Actor]()
        json.array?.forEach({ (jsonItem) in
            if let actor = Actor(json: jsonItem) {
                actors.append(actor)
            }
        })

        return actors
    }
}
