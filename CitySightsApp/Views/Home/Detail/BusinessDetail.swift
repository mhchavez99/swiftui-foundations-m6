//
//  BusinessDetail.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/28/21.
//

import SwiftUI

struct BusinessDetail: View {
    
    var business:Business
    @State private var showDirections = false
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            VStack(alignment: .leading, spacing: 0){
                
                GeometryReader(){ geo in
                    
                    //business image
                                let uiImage = UIImage(data: business.imageData ?? Data())
                                Image(uiImage: uiImage ?? UIImage() )
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .clipped()
                }
                .ignoresSafeArea(.all, edges: .top)
                
                
                //open/closed indicator
                ZStack(alignment: .leading){
                    
                    Rectangle()
                        .frame(height: 36)
                        .foregroundColor(business.isClosed! ? .gray : .blue)
                    Text(business.isClosed! ? "Closed" : "Open")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.leading)
                }
                
            }
        
            Group{
               
                HStack {
                    BusinessTitle(business: business)
                        .padding()
                    Spacer()
                    YelpAttribution(link: business.url ?? "https://yelp.com")
                }
                
                DashedDivider()
                    .padding(.horizontal)
                
                //phone
                HStack{
                    Text("Phone:")
                        .bold()
                    Text(business.displayPhone ?? "")
                    Spacer()
                    Link("Call", destination: URL(string: "tel:\(business.phone ?? "")")!)
                }
                .padding()
                
                DashedDivider()
                    .padding(.horizontal)
                
                //reviews
                HStack{
                    Text("Reviews:")
                        .bold()
                    Text(String(business.reviewCount ?? 0))
                    Spacer()
                    Link("Read", destination: URL(string: "\(business.url ?? "")")!)
                }
                .padding()
                
                DashedDivider()
                    .padding(.horizontal)
                
                //website
                HStack{
                    Text("Website:")
                        .bold()
                    Text(business.url ?? "")
                        .lineLimit(1)
                    Spacer()
                    Link("Visit", destination: URL(string: "\(business.url ?? "")")!)
                }
                .padding()
                
                DashedDivider()
                    .padding(.horizontal)
                
            }
            
            //get directions button
            
            Button {
                //show directions
                showDirections = true
                
            } label: {
                ZStack{
                    Rectangle()
                        .frame(height: 48)
                        .foregroundColor(.blue)
                    Text("Get Directions")
                        .foregroundColor(.white)
                        .bold()
                        .cornerRadius(10)
                }
            }
            .padding()
            .sheet(isPresented: $showDirections) {
                DirectionsView(business: business)
            }
            
        }
        
    }
}

