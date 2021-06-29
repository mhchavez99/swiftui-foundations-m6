//
//  BusinessTitle.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/28/21.
//

import SwiftUI

struct BusinessTitle: View {
    
    var business: Business
    
    var body: some View {
        
        VStack(alignment: .leading){
            //business name
            Text(business.name!)
                .font(.title2)
                .bold()
                
            //loop through display address
            if business.location?.displayAddress != nil{
                ForEach(business.location!.displayAddress!, id: \.self){ displayLine in
                    
                    Text(displayLine)
                        
                }
            }
            
            //rating
            
            Image("regular_\(business.rating ?? 0)")
                
            
        }
     
    }
}


