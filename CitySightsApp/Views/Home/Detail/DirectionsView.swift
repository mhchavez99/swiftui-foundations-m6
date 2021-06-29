//
//  DirectionsView.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/28/21.
//

import SwiftUI

struct DirectionsView: View {
    
    var business:Business
    
    var body: some View {
        VStack(alignment: .leading){
            
            //business tile
            HStack{
                BusinessTitle(business: business)
                    
                Spacer()
                
                if let lat = business.coordinates?.latitude,
                   let long = business.coordinates?.longitude,
                   let name = business.name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    {
                    Link("Open in Maps", destination: URL(string: "http://maps.apple.com/?ll=\(lat),\(long)&q=\(name)")!)

                }
            }
            .padding()
            //directions map
            
            DirectionsMap(business: business)
                .ignoresSafeArea(.all, edges: .bottom)
            
        }
    }
}

