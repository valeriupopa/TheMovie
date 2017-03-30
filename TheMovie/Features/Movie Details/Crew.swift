//
//  Crew.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/10/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONObjectInitialization {
    init?(json: JSON)
}

struct Crew: JSONObjectInitialization {
    
    let creditID: String
    let department: String
    let id: Int
    let job: String
    let name: String
    let profilePath: URL?
    
    init?(json: JSON) {
        guard let creditID = json["credit_id"].string else {
            return nil
        }
        self.creditID = creditID
        
        self.department = json["department"].stringValue
        
        guard let id = json["id"].int else {
            return nil
        }
        self.id = id
        
        self.job = json["job"].stringValue
        self.name = json["name"].stringValue
        self.profilePath = URL(string: json["profile_path"].stringValue)
    }
    
    // Extract credits from json received from api.
    static func build(json: JSON) -> [Crew] {
        var crew = [Crew]()
        json.array?.forEach({ (jsonElement) in
            if let movie = Crew(json: jsonElement) {
                crew.append(movie)
            }
        })
        
        return Array(crew.prefix(6))
    }
}
