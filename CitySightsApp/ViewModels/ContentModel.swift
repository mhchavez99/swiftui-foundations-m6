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
        
        let userLocation = locations.first
        
        if userLocation != nil{
            //we have a location
            //stop geolocation
            locationManager.stopUpdatingLocation()
            
            //if we have coordinates, send them into yelp api
            //getBusinesses(category: "arts", location: userLocation!)
            getBusinesses(category: "restaurants", location: userLocation!)
        }
        
         
    }
    
    //MARK: Yelp api methods
    func getBusinesses(category: String, location: CLLocation){
        
        //create URL
        /*
        let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
        let url = URL(string: urlString
        */
        
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude",  value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        
        if let url = urlComponents?.url{
            //create url request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer UY_4gXwiiTzkqnHE9YuZ2-uKOdyY0k-EbkI-iSZjCOCkuCcjb4RHh4bCpdiWRjb9vSyc-W2BbtEv4N5gGfrpyEmOughWpGal_NFE4Xj_ETJjClt6EWAG561Gn9zVYHYx", forHTTPHeaderField: "Authorization")
            
            //get url session
            let session = URLSession.shared
            
            //create data task
            let dataTask = session.dataTask(with: request) { data, response, error in
                //check that there isn't an error
                if error == nil{
                    print(response)
                }
            }
            //start the data task
            dataTask.resume()
            
        }
        
        
        
        
        
    }
}
