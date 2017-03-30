//
//  MapViewController.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/26/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    private let placesClient: GMSPlacesClient = GMSPlacesClient.shared()
    private let center = CLLocationCoordinate2D(latitude: 47.166, longitude: 27.580)
    private var camera : GMSMutableCameraPosition!
    private var mapView : GMSMapView!
    
    // MARK: UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setIcon(iconName: "themovie")
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.initMap()
    }
    
    private func initMap() {
        // Create a GMSCameraPosition that tells the map to display the
        self.camera = GMSMutableCameraPosition.camera(withLatitude: center.latitude, longitude: center.longitude, zoom: 12.0)
        self.mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        self.view.insertSubview(mapView, at: 1)
    
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = center
        marker.title = "Iasi"
        marker.snippet = "Romania"
        marker.map = mapView
    }
    
    // MARK: - UI Actions
    // Add a UIButton in Interface Builder, and connect the action to this function.
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    @IBAction func pickPlace(_ sender: UIButton) {
        
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.nameLabel.text = place.name
                self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
                
                self.mapView.camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 12)
                self.mapView.clear()
                
                let marker = GMSMarker()
                marker.position = place.coordinate
                marker.title = place.name
                marker.snippet = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
                marker.map = self.mapView

                
            } else {
                self.nameLabel.text = "No place selected"
                self.addressLabel.text = ""
            }
        })
    }
}
