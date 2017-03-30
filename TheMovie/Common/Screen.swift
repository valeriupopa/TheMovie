//
//  Screen.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/13/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

// Enum of screens in application.
enum Screen {
    case movies
    case actors
    case login
    case register
    case profile
    case sideMenu
    case favorites
    case map
    
    var identifier: String {
        
        var viewControllerClass: AnyClass?
        switch self {
        case .login:
            viewControllerClass = LoginViewController.self
        case .register:
            viewControllerClass = RegisterViewController.self
        case .movies:
            viewControllerClass = MovieListViewController.self
        case .profile:
            viewControllerClass = ProfileViewController.self
        case .actors:
            viewControllerClass = ActorListViewController.self
        case .sideMenu:
            viewControllerClass = SideMenuViewController.self
        case .favorites:
            viewControllerClass = FavoritesListViewController.self
        case .map:
            viewControllerClass = MapViewController.self
        }
        
        guard let targetClass = viewControllerClass else {
            return ""
        }
        
        return "\(targetClass)"
    }
    
    var storyboardIdentifier: StoryboardIdentifier {
        switch self {
        case .login,.register:
            return .authentication
        case .movies, .favorites:
            return .movies
        case .actors:
            return .actors
        case .profile:
            return .authentication
        case .sideMenu:
            return .sideMenu
        case .map:
            return .map
        }
    }
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.storyboardIdentifier.name, bundle: Bundle.main)
    }
    
    var viewController: UIViewController {
        return self.storyboard.instantiateViewController(withIdentifier: self.identifier)
    }
}

enum StoryboardIdentifier: String {
    
    case authentication = "Authentication"
    case actors = "ActorList"
    case sideMenu = "SideMenu"
    case movieDetails = "MovieDetails"
    case movies = "MovieList"
    case map = "Map"
    
    var name: String {
        return self.rawValue
    }
}
