//
//  Business.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/25/21.
//

import Foundation


struct BusinessSearch: Decodable {
    
    var businesses = [Business]()
    var total = 0
    var region = Region()
}

struct Region: Decodable {
    var center = Coordinate()
}


class Business: Decodable, Identifiable, ObservableObject {
    
    @Published var imageData: Data?
    
    var id: String?
    var alias: String?
    var name: String?
    var imageUrl: String?
    var isClosed: Bool?
    var url: String?
    var reviewCount: Int?
    var categories: [Category]?
    var rating: Double?
    var coordinates: Coordinate?
    var transactions: [String]?
    var price: String?
    var location: Location?
    var phone: String?
    var displayPhone: String?
    var distance: Double?
    var isOpen: Bool?
    
    enum CodingKeys: String, CodingKey{
        case imageUrl = "image_url"
        case isClosed = "is_closed"
        case reviewCount = "review_count"
        case displayPhone = "display_phone"
        case id
        case alias
        case name
        case url
        case categories
        case rating
        case coordinates
        case transactions
        case price
        case location
        case phone
        case distance
        
    }
    
    func getIsOpen(){
        
        guard id != nil else{
            return
        }
        
        if let url = URL(string: Constants.detailsURL + id!){
        
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if error == nil{
                    do{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(BusinessDetails.self, from: data!)
                        
                        if result.hours != nil && result.hours!.count > 0{
                            
                            DispatchQueue.main.async {
                                self.isOpen = result.hours![0].is_open_now
                            }
                        }
                        
                        
                        
                    }catch{
                        print(error)
                        print("failed to decode json data")
                    }
                    
                }
            }
            
            dataTask.resume()
            
            
        }
        
    }
    
    func getImageData(){
        
        //check image url isn't nil
        
        guard imageUrl != nil else{
            return
        }
        
        //download the data for the image
        if let url = URL(string: imageUrl!){
            //get a session
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { data, response, error in
                if error == nil{
                    
                    DispatchQueue.main.async {
                        //set the image data
                        self.imageData = data!
                    }
                    
                }
            }
            dataTask.resume()
        }
        
        
        
    }
    
}

struct Location: Decodable {
    var address1: String?
    var address2: String?
    var address3: String?
    var city: String?
    var zipCode: String?
    var country: String?
    var state: String?
    var displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey{
        case zipCode = "zip_code"
        case displayAddress = "display_address"
        case address1
        case address2
        case address3
        case city
        case country
        case state
    }
}

struct Category: Decodable {
    var alias: String?
    var title: String?
}

struct Coordinate: Decodable {
    var latitude: Double?
    var longitude: Double?
}



struct BusinessDetails: Decodable{
    var hours:[HourInfo]?
}

struct HourInfo: Decodable{
    var is_open_now:Bool?
}

