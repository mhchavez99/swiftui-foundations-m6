//
//  BusinessSection.swift
//  CitySightsApp
//
//  Created by Michael Chavez on 6/25/21.
//

import SwiftUI

struct BusinessSection: View {
    
    var title: String
    var businesses: [Business]
    
    var body: some View {
        
        Section(header: BusinessSectionHeader(title: title)){
            ForEach(businesses){ business in
                BusinessRow(business: business)

                
            }
        }
    }
}


