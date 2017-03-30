//
//  Credit.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/9/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Cast: JSONObjectInitialization {
    let castID: Int
    let character: String
    let creditID: String
    let id: Int
    let name: String
    let order: Int
    let profilePath: URL?
    
    init?(json: JSON) {
        self.castID = json["cast_id"].intValue
        self.character = json["character"].stringValue
        self.creditID =  json["credit_id"].stringValue
        guard let id = json["id"].int else {
            return nil
        }
        self.id = id
        self.name = json["name"].stringValue
        self.order = json["order"].intValue
        self.profilePath = URL(string: API.imagePath + json["profile_path"].stringValue)
    }
    
    // Extract credits from json received from api.
    static func build(json: JSON) -> [Cast] {
        var credits = [Cast]()
        json.array?.forEach({ (jsonElement) in
            if let movie = Cast(json: jsonElement) {
                credits.append(movie)
            }
        })
        
        return Array(credits.prefix(6))
    }
}
