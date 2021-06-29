//
//  YelpAttribution.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/29/21.
//

import SwiftUI

struct YelpAttribution: View {
    
    var link: String
    
    var body: some View {
        
        Link(destination: URL(string: link)!, label: {
            Image("yelp")
                .resizable()
                .scaledToFit()
                .frame(height: 36)
        })
        
        
    }
}

