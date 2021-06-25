//
//  BusinessRow.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/25/21.
//

import SwiftUI

struct BusinessRow: View {
    
    @ObservedObject var business:Business
    
    var body: some View {
        
        VStack(alignment: .leading){
            HStack{
                //Image
                let uiImage = UIImage(data: business.imageData ?? Data())
                Image(uiImage: uiImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 58)
                    .cornerRadius(5)
                
                //Name and distance
                VStack(alignment: .leading){
                    Text(business.name ?? "")
                    Text(String(format: "%.1f miles away", 0.000621371*(business.distance ?? 0)))
                        .font(.caption)
                }
                Spacer()
                //star rating an number of reviews
                VStack(alignment: .leading){
                    Image("regular_\(business.rating ?? 0)")
                    Text("\(business.reviewCount ?? 0) reviews")
                        .font(.caption)
                    
                }
            }
            Divider()
        }
    }
}

//struct BusinessRow_Previews: PreviewProvider {
//    static var previews: some View {
//        BusinessRow()
//    }
//}
