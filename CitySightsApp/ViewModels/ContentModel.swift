//
//  ContentModel.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/24/21.
//

import Foundation
import CoreLocation


class ContentModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override init (){
        super.init()
        
        //set content model as the delegate of the location manager
        locationManager.delegate = self
        
        //Request permission from the user
        locationManager.requestWhenInUseAuthorization()
        
       
        
    }
    
    // MARK: - Location Manager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse{
            //we have permission, start geolocating
            locationManager.startUpdatingLocation()
            
        }else if locationManager.authorizationStatus == .denied{
            //we don't have permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //gives us the location of the user
        print(locations.first ?? "no location")
        
        
        //stop requesting the location after we get it once
        locationManager.stopUpdatingLocation()
        
        //TODO: if we have the coordinates of the user, send to yelp api
        
    }
    
}
