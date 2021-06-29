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
    
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    @Published var placemark:CLPlacemark?
    
    override init (){
        super.init()
        
        //set content model as the delegate of the location manager
        locationManager.delegate = self
    }
    
    func requestGeolocationPermission(){
        //Request permission from the user
                locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Location Manager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        //update authorization state property
        authorizationState = locationManager.authorizationStatus
        
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
            
            //get the placemark of the user
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(userLocation!) { placemarks, error in
                //check that there aren't errors
                if error == nil && placemarks != nil{
                    //take the first placemark
                    self.placemark = placemarks!.first
                }
            }
            
            //if we have coordinates, send them into yelp api
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            getBusinesses(category: Constants.restaurantsKey, location: userLocation!)
        }
        
         
    }
    
    //MARK: Yelp api methods
    func getBusinesses(category: String, location: CLLocation){
        
        //create URL
        /*
        let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
        let url = URL(string: urlString
        */
        
        var urlComponents = URLComponents(string: Constants.apiURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude",  value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "10")
        ]
        
        if let url = urlComponents?.url{
            //create url request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
            
            //get url session
            let session = URLSession.shared
            
            //create data task
            let dataTask = session.dataTask(with: request) { data, response, error in
                //check that there isn't an error
                if error == nil{
                    
                    //parse JSON
                    
                    do{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(BusinessSearch.self, from: data!)
                        
                        // sort businesses by distance
                        var businesses = result.businesses
                        
                        businesses.sort { b1, b2 in
                            return b1.distance ?? 0 < b2.distance ?? 0
                        }
                        
                        
                        //call the get image function on the businesses
                        //call getIsOpen for each business
                        for b in businesses {
                            b.getImageData()
                            b.getIsOpen()
                        }
                        
                        DispatchQueue.main.async {
                            //Assign results to the appropriate property
                            if category == Constants.sightsKey{
                                self.sights = businesses
                                
                            }else if category == Constants.restaurantsKey{
                                self.restaurants = businesses
                            }
                        
                        }
                    }catch{
                        print(error)
                        print("failed to decode json data")
                    }
                    
                    
                }
            }
            //start the data task
            dataTask.resume()
            
        }
        
        
        
        
        
    }
}
