//
//  SideMenuViewModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/13/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SideMenuViewModel {
    let menuItems: Variable<[SideMenuData]> = Variable([
        SideMenuData(leftImage: "MovieList",
                    rightImage: "RightArrow",
                         title:"Movie List"),
        
        SideMenuData(leftImage: "ActorList",
                    rightImage: "RightArrow",
                         title:"Actors List"),
        
        SideMenuData(leftImage: "FavoritesList",
                    rightImage: "RightArrow",
                         title:"Favorites List"),

        SideMenuData(leftImage: "Profile",
                    rightImage: "RightArrow",
                         title:"Profile"),
        
        SideMenuData(leftImage: "Map",
                    rightImage: "RightArrow",
                         title:"Map")
        ])
    
    var viewController = PublishSubject<UIViewController>()
    
    func sideMenuAction(for index: Int) {
        
        var viewController: UIViewController?
        switch index {
        // movie list
        case 0:
            viewController = Screen.movies.viewController
        // actors list
        case 1:
            viewController = Screen.actors.viewController
        // favorite list
        case 2:
            viewController = Screen.favorites.viewController
        // profile
        case 3:
            viewController = Screen.profile.viewController
        // map
        case 4:
            viewController = Screen.map.viewController
        default: break
        }
        
        guard let controller = viewController else {
            return
        }
        
        self.viewController.onNext(controller)
    }
}
