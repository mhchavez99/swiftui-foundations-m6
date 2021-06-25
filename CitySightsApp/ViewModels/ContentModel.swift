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
            URLQueryItem(name: "limit", value: "6")
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
                        
                        DispatchQueue.main.async {
                            //Assign results to the appropriate property
                            if category == Constants.sightsKey{
                                self.sights = result.businesses
                                
                            }else if category == Constants.restaurantsKey{
                                self.restaurants = result.businesses
                            }
                        }
                    }catch{
                        print(error)
                    }
                    
                    
                }
            }
            //start the data task
            dataTask.resume()
            
        }
        
        
        
        
        
    }
}
